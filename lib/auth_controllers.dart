import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tfad_app/API_service.dart';
import 'package:tfad_app/basic.dart';
import 'package:tfad_app/loginScreen.dart';
import 'package:tfad_app/model/station.dart';
import 'package:tfad_app/verifyScreen.dart';

class AuthController extends GetxController {
  final count = 0.obs;
  final isLoading = false.obs;
  final responseMessage = ''.obs;
  var stations = <Station>[].obs;
  var questions = <Question>[].obs;
  var selectedStation = Rx<Station?>(null);

  void selectByNumber(String number) {
    final match = stations.firstWhereOrNull((s) => s.stationNumber == number);
    if (match != null) {
      selectedStation.value = match;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadStations();
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
}
