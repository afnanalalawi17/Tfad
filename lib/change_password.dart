
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tfad_app/auth_controllers.dart';
import 'package:tfad_app/shared/mainButton.dart';
import 'package:tfad_app/shared/textField.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  final authController = Get.put(AuthController());

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  void _submitChange() {
    if (!_formKey.currentState!.validate()) return;

    final current = currentController.text.trim();
    final newPass = newController.text.trim();
    final confirm = confirmController.text.trim();
authController.changePasswordAPI(current, newPass, confirm);
    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور الجديدة غير متطابقة')),
      );
      return;
    }

    authController.changePasswordAPI(current, newPass, confirm);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تغيير كلمة المرور')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PasswordField(
                  controller: currentController,
                  hintText: 'كلمة المرور الحالية',
                  obscureText: obscureCurrent,
                  toggleVisibility: () => setState(() => obscureCurrent = !obscureCurrent),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور الحالية';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: newController,
                  hintText: 'كلمة المرور الجديدة',
                  obscureText: obscureNew,
                  toggleVisibility: () => setState(() => obscureNew = !obscureNew),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: confirmController,
                  hintText: 'تأكيد كلمة المرور الجديدة',
                  obscureText: obscureConfirm,
                  toggleVisibility: () => setState(() => obscureConfirm = !obscureConfirm),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != newController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                MainButton(
                  title: 'تحديث كلمة المرور',
                  onPressed: _submitChange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}