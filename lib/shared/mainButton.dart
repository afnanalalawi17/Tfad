import 'package:flutter/material.dart';
import 'package:tfad_app/shared/appColor.dart';

class MainButton extends StatelessWidget {
  final String ?title;
  final VoidCallback ?onPressed;

  const MainButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(title!, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15  , color: Colors.white ),),
    );
  }
}
