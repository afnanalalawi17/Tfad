import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tfad_app/API_service.dart';
import 'package:tfad_app/basic.dart';
import 'package:tfad_app/loginScreen.dart';
import 'package:tfad_app/model/station.dart';
import 'package:tfad_app/verifyScreen.dart';

import 'model/QUESTION.dart';

class AuthController extends GetxController {
  final count = 0.obs;
  final isLoading = false.obs;
  final responseMessage = ''.obs;
  var stations = <Station>[].obs;
  var questions = <Question>[].obs;
  var selectedStation = Rx<StationApi?>(null);


  final List<File> selectedImages = [];

  @override
  void onInit() {
    super.onInit();
    loadStations();
    loadInit();
  }

  Future<void> loginAPI(String phone, String password) async {
    try {
      isLoading.value = true;
      final result = await ApiService.login(phone, password);
      responseMessage.value = result['message'] ?? 'Login successful';
      Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح",
          backgroundColor: Colors.green);
      Get.to(() => BasicView());
      loadStations();
      print('Response: $result');
    } catch (e) {
      Get.snackbar("خطأ", "هناك خطأ ما حاول مرة أخرى",
          backgroundColor: Colors.red);

      responseMessage.value = e.toString();
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePasswordAPI(String currentPassword, String newPassword,
      String newPasswordConfirmation) async {
    try {
      isLoading.value = true;
      final result = await ApiService.changePassword(
          currentPassword, newPassword, newPasswordConfirmation);
      responseMessage.value = result['message'] ?? 'changePassword successful';
       Get.snackbar("نجاح", "تم تحديث كلمة المرور بنجاح",
          backgroundColor: Colors.green);
      Get.to(() => BasicView());

      print('Response: $result');
    } catch (e) {
      Get.snackbar("خطأ", "هناك خطأ ما حاول مرة أخرى",
          backgroundColor: Colors.red);
      responseMessage.value = e.toString();
      print('changePassword error: $e');
    } finally {
      isLoading.value = false;
    }
  } Future<void> resetPasswordAPI(String phone, ) async {
    try {
      isLoading.value = true;
      final result = await ApiService.resetPassword(
          phone,);
      responseMessage.value = result['message'] ?? 'resetPassword successful';
    Get.to(() => VerificationCodeScreen(phoneNumber: '',));

      print('Response: $result');
    } catch (e) {
      Get.snackbar("خطأ", "هناك خطأ ما حاول مرة أخرى",
          backgroundColor: Colors.red);
      responseMessage.value = e.toString();
      print('resetPassword error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStations() async {
    try {
      isLoading.value = true;
      final data = await ApiService.fetchStations();
      stations.value = data.stations;
      questions.value = data.questions;
    } catch (e) {
      print("خطأ: $e");
      // Get.snackbar("خطأ", "تعذر تحميل البيانات", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void increment() => count.value++;
  final stationsApi = <StationApi>[].obs;
  final questionsApi = <QuestionApi>[].obs;
  final selectedStationApi = Rxn<StationApi>();
  final technicianName = 'الفني أحمد'.obs; // Example; bind to your box.read('name') if any

// answersMap: questionId -> either List<String> (checkbox) or String (radio)
  final answersMap = <int, dynamic>{}.obs;

  Future<void> loadInit() async {
    final (st, q) = await ApiService.fetchInit();
    stationsApi.assignAll(st);
    questionsApi.assignAll(q);
  }

  void selectByNumberApi(String stationNumber) {
    final s = stationsApi.firstWhereOrNull((e) => e.stationNumber == stationNumber);
    selectedStationApi.value = s;
  }
  static const _token = 'Bearer 4|uGSTtCLhKkkUooPH60eKB7ij9nOiVoJXBzz8iWvN6d24cba5';

  Future<Map<String, dynamic>> submitReport({
    required int userId,
  }) async {
    final base = 'https://report.daamup.sa/api';

// Optional: tolerate bad TLS in debug ONLY (remove in production)
// final httpClient = HttpClient()
// ..badCertificateCallback = (cert, host, port) => host == 'report.daamup.sa';
// final client = IOClient(httpClient);

    final uri = Uri.parse('$base/reports');
    final request = http.MultipartRequest('POST', uri);

// Headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': _token, // reuse same token string
    });

// Basic fields
    final stationId = selectedStation.value?.id;
    if (stationId == null) {
      throw Exception('لم يتم اختيار محطة');
    }
    request.fields['station_id'] = stationId.toString();
    request.fields['user_id'] = userId.toString();

// reports[] fields from answersMap
    var i = 0;
    answersMap.forEach((questionId, value) {
      request.fields['reports[$i][question_id]'] = questionId.toString();
      if (value is List) {
        for (final v in value) {
          final s = (v ?? '').toString().trim();
          if (s.isNotEmpty) {
            request.fields['reports[$i][answer][]'] = s;
          }
        }
      } else if (value is String) {
        final s = value.trim();
        if (s.isNotEmpty) {
          request.fields['reports[$i][answer][]'] = s;
        }
      }
      i++;
    });

// Attach images (optional)
    for (final f in selectedImages) {
      if (await f.exists()) {
        request.files.add(await http.MultipartFile.fromPath('images[]', f.path));
      }
    }

// Send request
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        return {'raw': body};
      }
    } else {
      throw Exception('HTTP ${streamed.statusCode}: $body');
    }
  }

}
