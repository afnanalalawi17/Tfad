import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tfad_app/model/station.dart';
 final box = GetStorage();
class ApiService {
  static const String baseUrl = "https://report.daamup.sa/api";
  
static Future<Map<String, dynamic>> login(String phone, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/login/phone"),
      headers: {
        'a': '',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "phone": phone,
        "password": password,
      }),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
       final user = body['user'];
      final token = body['token'];

      // ✅ تخزينها في GetStorage
      box.write('token', token);
      box.write('userID', user['id']);
      box.write('name', user['name']);
      box.write('email', user['email']);

      print("Saved token: $token");
      return body;
    } else {
      // Extract the error message from the response
      final message = body['message'] ?? 'Login failed';
      print("Error response: $message");
      throw Exception(message); // throw readable message
    }
  } catch (e) {
    print("Exception occurred: $e");
    rethrow;
  }
}
static Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword ,String newPasswordConfirmation) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/change/password"),
      headers: {
        'a': '',
        'Accept': 'application/json',
        'Content-Type': 'application/json','Authorization' : 'Bearer ${box.read('token')}'
      },
      body: json.encode({
       "current_password": currentPassword,
    "new_password": newPassword,
    "new_password_confirmation": newPasswordConfirmation
      }),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      return body;
    } else {
      // Extract the error message from the response
      final message = body['message'] ?? 'changePassword failed';
      print("Error response: $message");
      throw Exception(message); // throw readable message
    }
  } catch (e) {
    print("Exception occurred: $e");
    rethrow;
  }
}
static Future<Map<String, dynamic>> resetPassword(String phone,) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/forget/password"),
      headers: {
        'a': '',
        'Accept': 'application/json',
        'Content-Type': 'application/json','Authorization' : 'Bearer ${box.read('token')}'
      },
      body: json.encode({
       "phone": phone,
   
      }),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      return body;
    } else {
      // Extract the error message from the response
      final message = body['message'] ?? 'resetPassword failed';
      print("Error response: $message");
      throw Exception(message); // throw readable message
    }
  } catch (e) {
    print("Exception occurred: $e");
    rethrow;
  }
}

 static   Future<StationResponse> fetchStations() async {
  final response = await http.get(
      Uri.parse("$baseUrl/stations"),
      headers: {
        // 'a': '',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${box.read('token')}'
      },
     
    );

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    return StationResponse.fromJson(jsonBody);
  } else {
    throw Exception("فشل في جلب البيانات: ${response.statusCode}");
  }
 }
static Future<void> submitReport({
  required String token,
  required String stationId,
  required int userId,
  required List<Map<String, dynamic>> reports, // [ {question_id: 1, answers: ['a','b']} ]
  required List<File> images,
}) async {
  final url = Uri.parse('https://report.daamup.sa/api/reports');
  final request = http.MultipartRequest('POST', url);

  // Headers
  request.headers.addAll({
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  // Basic fields
  request.fields['station_id'] = stationId.toString();
  request.fields['user_id'] = userId.toString();

  // Dynamic fields for reports
  for (int i = 0; i < reports.length; i++) {
    final report = reports[i];
    final qid = report['question_id'].toString();
    final List<String> answers = List<String>.from(report['answers']);

    request.fields['reports[$i][question_id]'] = qid;

    for (var answer in answers) {
      request.fields['reports[$i][answer][]'] = answer;
    }
  }

  // Add images
  for (var image in images) {
    request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      print("تم الإرسال بنجاح: $resBody");
    } else {
      print("فشل الإرسال: ${response.statusCode} - ${response.reasonPhrase}");
      final error = await response.stream.bytesToString();
      print("تفاصيل الخطأ: $error");
    }
  } catch (e) {
    print("خطأ في الاتصال: $e");
  }
}


}
