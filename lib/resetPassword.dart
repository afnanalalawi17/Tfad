
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tfad_app/auth_controllers.dart';
import 'package:tfad_app/shared/mainButton.dart';
import 'package:tfad_app/shared/textField.dart'; // تأكد أن CustomPhoneField يدعم TextFormField و validator

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final authController = Get.put(AuthController());

  void _submitPhone() {
    if (!_formKey.currentState!.validate()) return;

    final phone = phoneController.text.trim();
    authController.resetPasswordAPI(phone); // تأكد أن لديك هذه الدالة
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعادة تعيين كلمة المرور'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'يرجى إدخال رقم الهاتف المرتبط بحسابك لإرسال رمز التحقق.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomPhoneField(
                  phoneController: phoneController, onChanged: (String ) {  },
                 
                ),
                const SizedBox(height: 32),
                MainButton(
                  title: 'إرسال رمز التحقق',
                  onPressed: _submitPhone,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
