import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tfad_app/auth_controllers.dart';
import 'package:tfad_app/loginScreen.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:tfad_app/shared/mainButton.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationCodeScreen({super.key, required this.phoneNumber});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final authController = Get.put(AuthController());
  String otpCode = "";

  late Timer _timer;
  int _resendSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  void _resendCode() {
    if (_resendSeconds == 0) {
      // authController.resendOtp(widget.phoneNumber);
      _startTimer(); // restart the timer
    }
  }

  void _verifyCode() {
    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رمز مكون من 4 أرقام على الأقل')),
      );
      return;
    }
 Get.to(() => LoginScreen());
    // authController.verifyOtpCode(widget.phoneNumber, otpCode);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('رمز التحقق')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'أدخل رمز التحقق المرسل إلى ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  autoFocus: true,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    activeFillColor: Colors.white,
                    inactiveColor: Colors.grey.shade400,
                    selectedColor:AppColors.primaryColor,
                    activeColor: Colors.green,
                  ),
                  onChanged: (value) => otpCode = value,
                ),
              ),
              const SizedBox(height: 32),
              MainButton(
                title: 'تحقق',
                onPressed: _verifyCode,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _resendSeconds == 0 ? _resendCode : null,
                child: Text(
                  _resendSeconds == 0
                      ? 'إعادة إرسال الرمز'
                      : 'إعادة الإرسال خلال $_resendSeconds ثانية',
                  style: TextStyle(
                    color: _resendSeconds == 0
                        ? AppColors.primaryColor
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
