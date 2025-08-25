// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hi_law_app/shared/appColor.dart';
// import 'package:hi_law_app/view/docList.dart';
// import 'package:hi_law_app/view/document.dart';
// import 'package:hi_law_app/view/fileScreen.dart';
// import 'package:hi_law_app/view/homeScreen.dart';
// import 'package:hi_law_app/view/setting/setting.dart';

// class BottomNavBasic extends StatefulWidget {
//   const BottomNavBasic({super.key});

//   @override
//   State<BottomNavBasic> createState() => _BottomNavBasicState();
// }

// class _BottomNavBasicState extends State<BottomNavBasic> {
//   int _currentIndex = 0;

//   final List<BottomNavigationBarItem> _items = [
//     BottomNavigationBarItem(
//       icon:SvgPicture.asset("assets/images/Home.svg"),
//       label: 'الرئيسية',
//         activeIcon: SvgPicture.asset("assets/images/HomeActive.svg")
//     ),
//     BottomNavigationBarItem(
//       icon: SvgPicture.asset("assets/images/Paper.svg"),
//       label: 'الخدمات',
//       activeIcon: SvgPicture.asset("assets/images/PaperActive.svg")
//     ),
//     BottomNavigationBarItem(
//       icon: SvgPicture.asset("assets/images/Folder.svg"),
//       label: 'غرف البيانات',
//       activeIcon: SvgPicture.asset("assets/images/FolderActive.svg")
//     ),
//     BottomNavigationBarItem(
//       icon:SvgPicture.asset("assets/images/Profile.svg"),
//       label: 'البروفايل',
//    activeIcon: SvgPicture.asset("assets/images/ProfileActive.svg")
//     ),
//   ];
//   final List<Widget> _screens = [
//     HomeScreen(),
//     FilesScreen(),
   
//     DocumentsListScreen(), SettingScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//   body: _screens[_currentIndex],
//   bottomNavigationBar: BottomNavigationBar(
//     currentIndex: _currentIndex,
//     onTap: (index) {
//       setState(() {
//         _currentIndex = index;
//       });
//     },
//     type: BottomNavigationBarType.fixed,
//     backgroundColor: Colors.white,
//     selectedItemColor: AppColors.primaryColor, // ✅ اللون النشط
//     unselectedItemColor: Colors.grey.shade400, // ✅ اللون غير النشط
//     selectedLabelStyle: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
//     unselectedLabelStyle: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
//     items: _items,
//   ),
// );
//   }}