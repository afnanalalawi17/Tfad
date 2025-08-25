import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tfad_app/auth_controllers.dart';
import 'package:tfad_app/basic.dart';
import 'package:tfad_app/resetPassword.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:tfad_app/shared/mainButton.dart';
import 'package:tfad_app/shared/textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey, // 🔐 Add form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  "assets/images/Artboard 1.png",
                  height: 150,
                  width: 150,
                )),
                const SizedBox(height: 32),

                const Text('رقم الهاتف'),
                const SizedBox(height: 8),
                CustomPhoneField(
                  phoneController: phoneController,
                  onChanged: (value) {
                    print('رقم الجوال كامل: $value');
                  },
                
                ),

                const Text('كلمة المرور'),
                const SizedBox(height: 8),
                PasswordField(
                  controller: passwordController,
                  hintText: 'ادخل كلمة المرور هنا',
                  obscureText: hidePassword,
                  toggleVisibility: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                     Get.to(() => ResetPasswordScreen());
                    },
                    child: const Text('نسيت كلمة المرور؟',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 16),
                MainButton(
                  title: 'تسجيل الدخول',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ✅ All inputs are valid
                      authController.loginAPI(
                        phoneController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}