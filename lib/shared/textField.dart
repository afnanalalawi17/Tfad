
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback toggleVisibility;
 final FormFieldValidator<String>? validator;

  const PasswordField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.toggleVisibility, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        ),
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }
}
class CustomPhoneField extends StatelessWidget {
  final Function(String) onChanged;
  final String initialCountryCode;
  final String hintText;
  final TextEditingController phoneController ;

  const CustomPhoneField({
    Key? key,
    required this.onChanged,
    this.initialCountryCode = 'SA',
    this.hintText = '5XXXXXXX', required this.phoneController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
       validator: (value) {
                    if (value == null ) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                   
                    return null;
                  },
      controller: phoneController,
      textAlign: TextAlign.left,
      languageCode: 'ar',
      initialCountryCode: initialCountryCode,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xff0000001A).withOpacity(0.3),
          fontFamily: 'IBMPlexSansArabic', // خط اختياري
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xffEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xffEEEEEE)),
        ),
      ),
      onChanged: (phone) {
        print(phoneController.text.toString());
        onChanged(phone.completeNumber); // ترجع الرقم كامل
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final String? icon;
 final TextEditingController ? textController ;
  const CustomTextField({ this.label, required this.hint,  this.icon,  this.textController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            
            hintText: hint, hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
            prefixIcon:  Padding(
      padding: const EdgeInsets.all(12), // تضبط المسافة حول الأيقونة
      child: SvgPicture.asset(
        icon!,
        height: 20,
        width: 20,
        fit: BoxFit.contain,
      ),
    ),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class DropDownField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const DropDownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint ?? '', textAlign: TextAlign.right , style:  TextStyle(color: Color(0xff0000001A).withOpacity(.3),fontWeight: FontWeight.w500, fontFamily: "IBMPlexSansArabic"),),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, textAlign: TextAlign.right),
            )).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffEEEEEE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffEEEEEE)),
              ),
            ),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}class DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const DatePickerField({required this.label,  this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller!.text = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
            decoration: InputDecoration(
              hintText: 'اختر تاريخ الميلاد ', hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
              suffixIcon:Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/images/Calendar.svg", height: 20 ,width: 20,fit: BoxFit.fill,),
              ),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
             enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xffEEEEEE)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xffEEEEEE)),
    ),
            ),
          ),
        ],
      ),
    );
  }
}
