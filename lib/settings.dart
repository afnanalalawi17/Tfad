import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tfad_app/change_password.dart';
import 'package:tfad_app/editProfile.dart';
import 'package:tfad_app/termAndCondition.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // حالات المفاتيح (ON/OFF)
  bool notificationsEnabled = false;
  bool lightMode = true;
  bool quickLogin = false;
  bool signLanguage = false;

  @override
  Widget build(BuildContext context) {
    var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 30),

            settingTile("الملف الشخصي", Icons.person_3_outlined, () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditAccountScreen()));
            }),
          const SizedBox(height: 24),
            settingTile("تغيير كلمة المرور", Icons.lock, (){  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChangePasswordScreen()));}),
          const SizedBox(height: 24),
          settingTile("سياسية الخصوصية", Icons.article_rounded , (){  Navigator.push(context, MaterialPageRoute(builder: (context) =>  TermsAndConditionsScreen()));}),
          const SizedBox(height: 24),
     
          settingTile("الشروط والاحكام", Icons.article_rounded, (){  Navigator.push(context, MaterialPageRoute(builder: (context) =>  TermsAndConditionsScreen()));}),
          const SizedBox(height: 24),
        ],
      ),
    );
  }



  Widget settingTile(String title, IconData icon , Function() ? onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: onTap,
      ),
    );
  }
}
