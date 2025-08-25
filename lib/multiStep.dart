// import 'dart:io';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:intl/intl.dart';
// import 'package:tfad_app/API_service.dart';
// import 'package:tfad_app/auth_controllers.dart';
// import 'package:tfad_app/basic.dart';
// import 'package:tfad_app/model/station.dart';
// import 'package:tfad_app/shared/appColor.dart';
// import 'package:tfad_app/shared/textField.dart';

// final authController = Get.put(AuthController());

// Map<String, bool> checkedItems = {
//   'fuse1': false,
//   'fuse2': false,
//   'fuse3': false,
//   'other': false,
//   'breaker1': false,
//   'breaker2': false,
// };
// Map<String, bool> upsChecks = {
//   'upsCheck1': false,
//   'upsCheck2': false,
//   'upsCheck3': false,
//   'upsCheck4': false,
//   'otherUps': false,
// };

// // Battery radio group state
// String batteryValue = 'battery1';
// TextEditingController otherTextController = TextEditingController();
// // الحالة للبطاقة الأولى (كروت التحكم)
// Map<String, bool> controlCardChecks = {
//   'checked0': false,
//   'checked1': false,
//   'checked2': false,
//   'checked3': false,
//   'other1': false,
// };

// // الحالة للبطاقة الثانية (برمجة)
// Map<String, bool> programmingChecks = {
//   'prog1': false,
//   'prog2': false,
//   'prog3': false,
// };

// TextEditingController other1TextController = TextEditingController();
// File? _image;

// class MultiStepFormScreen extends StatefulWidget {
//   const MultiStepFormScreen({super.key});

//   @override
//   State<MultiStepFormScreen> createState() => _MultiStepFormScreenState();
// }

// class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
//   int currentStep = 0;

//   final List<Widget> steps = [];

//   @override
//   void initState() {
//     super.initState();
//     steps.addAll([
//       _PartnerDataStep(),
//       _CompanyPurposeStep(),
//       _CompanyManagementStep(),
//       _CompanyDecisionsStep(),
//       _ProfitLossDistributionStep(),
//     ]);
//   }

//   void _nextStep() {
//     if (currentStep < steps.length - 1) {
//       setState(() {
//         currentStep++;
//       });
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 BasicView()), // غيّر NextScreen لشاشتك التالية
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var heightApp = MediaQuery.of(context).size.height;
//     var widthApp = MediaQuery.of(context).size.width;
//     double progress = (currentStep + 1) / steps.length;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             _HeaderSection(
//                 currentStep: currentStep,
//                 totalSteps: steps.length,
//                 progress: progress),
//             const SizedBox(height: 16),
//             Expanded(child: steps[currentStep]),
//             _NextButton(onTap: _nextStep),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HeaderSection extends StatelessWidget {
//   final int currentStep;
//   final int totalSteps;
//   final double progress;

//   const _HeaderSection(
//       {required this.currentStep,
//       required this.totalSteps,
//       required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor.withOpacity(.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text('${currentStep + 1}/$totalSteps',
//                     style: const TextStyle(
//                         fontSize: 14, color: AppColors.primaryColor)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             currentStep == 0
//                 ? 'بيانات الفرقة والمحطة'
//                 : currentStep == 1
//                     ? "AC نظام التيار المتردد"
//                     : currentStep == 2
//                         ? "DC أنظمة التيار المستمر"
//                         : currentStep == 3
//                             ? "RTU أنظمة التحكم"
//                             : currentStep == 4
//                                 ? "مرفقات أنظمة التحكم"
//                                 : 'هنا النص هو مثال لنص يمكن أن يستبدل في نفس الساحة',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.right,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "في حال فحص او تركيب اي شي لازم صورة قبل و بعد",
//             style: TextStyle(color: Colors.grey, fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           LinearProgressIndicator(
//             minHeight: 20,
//             borderRadius: BorderRadius.circular(20),
//             value: progress,
//             backgroundColor: AppColors.primaryColor.withOpacity(.1),
//             color: AppColors.primaryColor,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PartnerDataStep extends StatefulWidget {
//   const _PartnerDataStep();

//   @override
//   State<_PartnerDataStep> createState() => _PartnerDataStepState();
// }

// class _PartnerDataStepState extends State<_PartnerDataStep> {
//   final TextEditingController birthDateController = TextEditingController();
//   String? selectedNationality;
//   String? selectedResidence;
//   String? selectedCity;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(24),
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("اسم الفني",
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               TextField(
//                 readOnly: true,
//                 textAlign: TextAlign.right,
//                 decoration: InputDecoration(
//                   hintText: box.read('name').toString(),
//                   hintStyle: TextStyle(color: Colors.black),
//                   filled: true,
//                   fillColor: const Color(0xFFF7F7F7),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Obx(() {
//           return DropdownSearch<Station>(
//             items: authController.stations.toList(),
//             itemAsString: (station) => station.stationNumber,
//             selectedItem: authController.selectedStation.value,
//             onChanged: (station) {
//               if (station != null) {
//                 authController
//                     .selectByNumber(station.stationNumber); // ← يحدث اسم المحطة
//               }
//               box.remove("stationNumber");
//               box.write("stationNumber", station!.stationNumber);
//             },
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 hintText: "اختر رقم المحطة",
//                 filled: true,
//                 fillColor: const Color(0xFFF7F7F7),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                 ),
//               ),
//             ),
//             popupProps: PopupProps.menu(showSearchBox: true),
//           );
//         }),
//         const SizedBox(height: 16),
//         Obx(() {
//           if (authController.selectedStation.value == null) {
//             return const SizedBox(); // يخفي العنصر تماماً
//           }

//           return DropdownSearch<Station>(
//             items: authController.stations.toList(),
//             itemAsString: (station) => station.stationName,
//             selectedItem: authController.selectedStation.value,
//             enabled: false,
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 hintText: "اسم المحطة",
//                 filled: true,
//                 fillColor: const Color(0xFFF7F7F7),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                 ),
//                 disabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// class _CustomTextField extends StatelessWidget {
//   final String label;
//   final String hint;

//   const _CustomTextField({required this.label, required this.hint});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           TextField(
//             textAlign: TextAlign.right,
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
//               filled: true,
//               fillColor: const Color(0xFFF7F7F7),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DatePickerField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;

//   const _DatePickerField({required this.label, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           TextField(
//             controller: controller,
//             textAlign: TextAlign.right,
//             readOnly: true,
//             onTap: () async {
//               DateTime? picked = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime.now(),
//               );
//               if (picked != null) {
//                 controller.text = DateFormat('yyyy-MM-dd').format(picked);
//               }
//             },
//             decoration: InputDecoration(
//               hintText: 'ادخل تاريخ الميلاد هنا',
//               hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
//               suffixIcon: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SvgPicture.asset(
//                   "assets/images/Calendar.svg",
//                   height: 20,
//                   width: 20,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               filled: true,
//               fillColor: const Color(0xFFF7F7F7),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DropDownField extends StatelessWidget {
//   final String label;
//   final String? hint;
//   final String? value;
//   final List<String> items;
//   final Function(String?) onChanged;

//   const _DropDownField({
//     required this.label,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     required this.hint,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<String>(
//             value: value,
//             hint: Text(
//               hint ?? '',
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                   color: Color(0xff0000001A).withOpacity(.3),
//                   fontWeight: FontWeight.w500,
//                   fontFamily: "IBMPlexSansArabic"),
//             ),
//             items: items
//                 .map((item) => DropdownMenuItem(
//                       value: item,
//                       child: Text(item, textAlign: TextAlign.right),
//                     ))
//                 .toList(),
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: const Color(0xFFF7F7F7),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Color(0xffEEEEEE)),
//               ),
//             ),
//             isExpanded: true,
//             icon: const Icon(Icons.keyboard_arrow_down),
//             style: const TextStyle(fontSize: 16, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CompanyPurposeStep extends StatefulWidget {
//   const _CompanyPurposeStep({super.key});

//   @override
//   State<_CompanyPurposeStep> createState() => _CompanyPurposeStepState();
// }

// class _CompanyPurposeStepState extends State<_CompanyPurposeStep> {
//   final answersMap = <int, List<String>>{}.obs;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(24),
//       children: [
//         buildCard(
//           title: "الكيبل و AC نظام التغذية التيار الفيوزات",
//           // subtitle: "الفيوزات",
//           items: {
//             'fuse1':
//                 "تم فحص جميع الفيوزات الخاصة بتغذية وحدة التحكم الأرضية 707000043",
//             'fuse2': "سليم",
//             'fuse3':
//                 "تم فحص أو تصحيح أو توصيل كيبل AC 220V من لوحة الجهد المنخفض 707000044",
//             'other': "Other:",
//           },onChanged: (selectedAnswers) {
//     answersMap[1] = selectedAnswers; // السؤال رقم 4 مثلاً
//   },
//         ),
//         buildCard(
//           title: "القاطع AC نظام التغذية التيار",
//           items: {
//             'breaker1': "تم فحص القاطع 707000036",
//             'breaker2': "تم تركيب أو استبدال قاطع 707000037",
//           },onChanged: (selectedAnswers) {
//     answersMap[1] = selectedAnswers; // السؤال رقم 4 مثلاً
//   },
//         ),
//       ],
//     );
//   }
// Widget buildCard({
//   required String title,
//   String? subtitle,
//   required Map<String, String> items,
//   required Function(List<String>) onChanged, // ترسل العناصر المختارة
// }) {
//   final checkedItems = <String, bool>{};
//   final otherTextController = TextEditingController();

//   // تهيئة القيم مبدئياً
//   items.forEach((key, _) => checkedItems[key] = false);

//   return StatefulBuilder(
//     builder: (context, setState) {
//       void updateAnswers() {
//         List<String> selected = checkedItems.entries
//             .where((e) => e.value)
//             .map((e) {
//               if (e.key == 'other') {
//                 return otherTextController.text.isNotEmpty
//                     ? otherTextController.text
//                     : 'أخرى';
//               }
//               return e.key;
//             })
//             .toList();

//         onChanged(selected); // ← تمرير القيم المختارة
//       }

//       return Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style:
//                       const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               if (subtitle != null)
//                 Text(subtitle, style: const TextStyle(fontSize: 14)),
//               const SizedBox(height: 10),
//               ...items.entries.map((entry) {
//                 if (entry.key == 'other') {
//                   return CheckboxListTile(
//                     activeColor: AppColors.primaryColor,
//                     value: checkedItems[entry.key],
//                     onChanged: (val) {
//                       setState(() {
//                         checkedItems[entry.key] = val!;
//                       });
//                       updateAnswers();
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("أخرى:"),
//                         if (checkedItems[entry.key]!)
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               child: TextField(
//                                 controller: otherTextController,
//                                 onChanged: (v) => updateAnswers(),
//                                 decoration: const InputDecoration(hintText: "اكتب هنا"),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return CheckboxListTile(
//                     activeColor: AppColors.primaryColor,
//                     value: checkedItems[entry.key],
//                     onChanged: (val) {
//                       setState(() {
//                         checkedItems[entry.key] = val!;
//                       });
//                       updateAnswers();
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                     title: Text(entry.value, textAlign: TextAlign.right),
//                   );
//                 }
//               }).toList(),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
// }

// class _CompanyManagementStep extends StatefulWidget {
//   const _CompanyManagementStep({Key? key}) : super(key: key);

//   @override
//   State<_CompanyManagementStep> createState() => _CompanyManagementStepState();
// }

// class _CompanyManagementStepState extends State<_CompanyManagementStep> {
//   final TextEditingController birthDateController = TextEditingController();
//   String? selectedNationality;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(24),
//       children: [
//         Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 3,
//             child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("DC UPS نظام التغذية التيار",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       CheckboxListTile(
//                         activeColor: AppColors.primaryColor,
//                         value: upsChecks['upsCheck4'],
//                         onChanged: (val) =>
//                             setState(() => upsChecks['upsCheck4'] = val!),
//                         title: const Text(
//                             "فحص وصيانة كروت خاص بشاحن البطارية UPS والتأكد من تغذيتها لأجهزة الوحدة الطرفية\n707000026"),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                       CheckboxListTile(
//                         activeColor: AppColors.primaryColor,
//                         value: upsChecks['upsCheck1'],
//                         onChanged: (val) =>
//                             setState(() => upsChecks['upsCheck1'] = val!),
//                         title: const Text("تحتاج استبدال UPS"),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                       CheckboxListTile(
//                         activeColor: AppColors.primaryColor,
//                         value: upsChecks['upsCheck2'],
//                         onChanged: (val) =>
//                             setState(() => upsChecks['upsCheck2'] = val!),
//                         title: const Text("تم الاستبدال لـ UPS و 707000027"),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                       CheckboxListTile(
//                         activeColor: AppColors.primaryColor,
//                         value: upsChecks['upsCheck3'],
//                         onChanged: (val) =>
//                             setState(() => upsChecks['upsCheck3'] = val!),
//                         title: const Text("UPS سليم"),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                       CheckboxListTile(
//                         activeColor: AppColors.primaryColor,
//                         value: upsChecks['otherUps'],
//                         onChanged: (val) =>
//                             setState(() => upsChecks['otherUps'] = val!),
//                         title: Row(
//                           children: [
//                             const Text("Other: "),
//                             if (upsChecks['otherUps']!)
//                               Expanded(
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: TextField(
//                                     decoration: const InputDecoration(
//                                         hintText: "اكتب هنا"),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       )
//                     ]))),
//         const SizedBox(height: 20),
//         Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 3,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("بطارية DC نظام التغذية التيار",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 buildRadio("battery1", "تركيب أو استبدال بطارية 707000040"),
//                 buildRadio("battery2", "تحتاج استبدال بطارية"),
//                 buildRadio("battery3", "البطارية سليمة"),
//                 buildRadio("other", "Other:"),
//                 if (batteryValue == "other")
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: TextField(
//                       controller: otherTextController,
//                       decoration: const InputDecoration(hintText: "اكتب هنا"),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildRadio(String value, String title) {
//     return RadioListTile(
//       activeColor: AppColors.primaryColor,
//       value: value,
//       groupValue: batteryValue,
//       onChanged: (val) {
//         setState(() {
//           batteryValue = val!;
//         });
//       },
//       title: Text(title),
//       controlAffinity: ListTileControlAffinity.leading,
//     );
//   }
// }

// class _CompanyDecisionsStep extends StatefulWidget {
//   const _CompanyDecisionsStep({super.key});

//   @override
//   State<_CompanyDecisionsStep> createState() => _CompanyDecisionsStepState();
// }

// class _CompanyDecisionsStepState extends State<_CompanyDecisionsStep> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(24),
//       children: [
//         Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 3,
//             child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("أنظمة التحكم (كروت التحكم)",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 6),
//                       ...[
//                         // "تم فحص جميع الكروت للوحدة الأرضية\n707000033"
//                         {
//                           'key': 'checked0',
//                           'label':
//                               "تم فحص جميع الكروت للوحدة الأرضية\n707000033"
//                         },
//                         {'key': 'checked1', 'label': "جميع الكروت سليمة"},
//                         {'key': 'checked2', 'label': "تحتاج استبدال كروت"},
//                       ].map((item) => CheckboxListTile(
//                             value: controlCardChecks[item['key']]!,
//                             onChanged: (val) => setState(
//                                 () => controlCardChecks[item['key']!] = val!),
//                             title: Text(item['label']!),
//                             controlAffinity: ListTileControlAffinity.leading,
//                           )),
//                       CheckboxListTile(
//                         value: controlCardChecks['other1'],
//                         onChanged: (val) =>
//                             setState(() => controlCardChecks['other1'] = val!),
//                         title: Row(
//                           children: [
//                             const Text("Other: "),
//                             if (controlCardChecks['other1']!)
//                               Expanded(
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: TextField(
//                                     controller: other1TextController,
//                                     decoration: const InputDecoration(
//                                         hintText: "اكتب هنا"),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         controlAffinity: ListTileControlAffinity.leading,
//                       )
//                     ]))),
//         const SizedBox(height: 20),
//         Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 3,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("أنظمة التحكم (برمجة)",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 ...[
//                   {'key': 'prog1', 'label': "سليم"},
//                   {
//                     'key': 'prog2',
//                     'label': "تم برمجة RTU و وحدة التحكم الطرفية\n707000038"
//                   },
//                   {'key': 'prog3', 'label': "لا يمكن البرمجة"},
//                 ].map((item) => CheckboxListTile(
//                       value: programmingChecks[item['key']]!,
//                       onChanged: (val) => setState(
//                           () => programmingChecks[item['key']!] = val!),
//                       title: Text(item['label']!),
//                       controlAffinity: ListTileControlAffinity.leading,
//                     )),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//     ;
//   }
// }

// class _ProfitLossDistributionStep extends StatefulWidget {
//   const _ProfitLossDistributionStep({super.key});

//   @override
//   State<_ProfitLossDistributionStep> createState() =>
//       _ProfitLossDistributionStepState();
// }

// class _ProfitLossDistributionStepState
//     extends State<_ProfitLossDistributionStep> {
//   final List<File> selectedImages = [];
//   final picker = ImagePicker();

//   Future<void> pickImage(ImageSource source) async {
//     if (selectedImages.length >= 9) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("You can only upload up to 9 images.")),
//       );
//       return;
//     }
//     final XFile? pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       final file = File(pickedFile.path);

//       final int fileSize = await file.length();
//       if (fileSize <= 10 * 1024 * 1024) {
//         setState(() {
//           selectedImages.add(file);
//         });
//       } else {
//         print("object");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("File exceeds 10MB limit")),
//         );
//       }
//     }
//   }

//   void showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 22, right: 22),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'أنظمة التحكم (برمجة) قبل وبعد',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               textAlign: TextAlign.right,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Upload up to 5 supported files: image. Max 10 MB per file.',
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 10),
//             OutlinedButton.icon(
//               onPressed: showImageSourceDialog,
//               icon: const Icon(
//                 Icons.upload_file,
//                 color: AppColors.primaryColor,
//               ),
//               label: const Text(
//                 'Add file',
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (selectedImages.isNotEmpty)
//               ...selectedImages.map(
//                 (file) => ListTile(
//                   title: Text(file.path.split('/').last),
//                   subtitle: FutureBuilder<int>(
//                     future: file.length(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         final mb =
//                             (snapshot.data! / (1024 * 1024)).toStringAsFixed(2);
//                         return Text('$mb MB');
//                       }
//                       return Text('Loading...');
//                     },
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       setState(() {
//                         selectedImages.remove(file);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NextButton extends StatelessWidget {
//   final VoidCallback onTap;

//   const _NextButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryColor,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: onTap,
//           child: const Text('التالي',
//               style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:tfad_app/API_service.dart';
import 'package:tfad_app/auth_controllers.dart';
import 'package:tfad_app/basic.dart';
import 'package:tfad_app/model/station.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:tfad_app/shared/textField.dart';

final authController = Get.put(AuthController());
 Map<int, dynamic> answersMap = {};

Map<String, bool> checkedItems = {
  'fuse1': false,
  'fuse2': false,
  'fuse3': false,
  'other': false,
  'breaker1': false,
  'breaker2': false,
};
Map<String, bool> upsChecks = {
  'upsCheck1': false,
  'upsCheck2': false,
  'upsCheck3': false,
  'upsCheck4': false,
  'otherUps': false,
};

// Battery radio group state
String batteryValue = 'battery1';
TextEditingController otherTextController = TextEditingController();
// الحالة للبطاقة الأولى (كروت التحكم)
Map<String, bool> controlCardChecks = {
  'checked0': false,
  'checked1': false,
  'checked2': false,
  'checked3': false,
  'other1': false,
};

// الحالة للبطاقة الثانية (برمجة)
Map<String, bool> programmingChecks = {
  'prog1': false,
  'prog2': false,
  'prog3': false,
};

TextEditingController other1TextController = TextEditingController();
File? _image;

class MultiStepFormScreen extends StatefulWidget {
  const MultiStepFormScreen({super.key});

  @override
  State<MultiStepFormScreen> createState() => _MultiStepFormScreenState();
}

class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
  int currentStep = 0;

  final List<Widget> steps = [];

  @override
  void initState() {
    super.initState();
    steps.addAll([
      _PartnerDataStep(),
      _CompanyPurposeStep(),
      _CompanyManagementStep(),
      _CompanyDecisionsStep(),
      _ProfitLossDistributionStep(),
    ]);
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BasicView()), // غيّر NextScreen لشاشتك التالية
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;
    double progress = (currentStep + 1) / steps.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _HeaderSection(
                currentStep: currentStep,
                totalSteps: steps.length,
                progress: progress),
            const SizedBox(height: 16),
            Expanded(child: steps[currentStep]),
            _NextButton(onTap: _nextStep),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progress;

  const _HeaderSection(
      {required this.currentStep,
      required this.totalSteps,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${currentStep + 1}/$totalSteps',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentStep == 0
                ? 'بيانات الفرقة والمحطة'
                : currentStep == 1
                    ? "AC نظام التيار المتردد"
                    : currentStep == 2
                        ? "DC أنظمة التيار المستمر"
                        : currentStep == 3
                            ? "RTU أنظمة التحكم"
                            : currentStep == 4
                                ? "مرفقات أنظمة التحكم"
                                : 'هنا النص هو مثال لنص يمكن أن يستبدل في نفس الساحة',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            "في حال فحص او تركيب اي شي لازم صورة قبل و بعد",
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            minHeight: 20,
            borderRadius: BorderRadius.circular(20),
            value: progress,
            backgroundColor: AppColors.primaryColor.withOpacity(.1),
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}

class _PartnerDataStep extends StatefulWidget {
  const _PartnerDataStep();

  @override
  State<_PartnerDataStep> createState() => _PartnerDataStepState();
}

class _PartnerDataStepState extends State<_PartnerDataStep> {
  final TextEditingController birthDateController = TextEditingController();
  String? selectedNationality;
  String? selectedResidence;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("اسم الفني",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: box.read('name').toString(),
                  hintStyle: TextStyle(color: Colors.black),
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
        ),  Text("رقم المحطة",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
        Obx(() {
          return DropdownSearch<Station>(
            items: authController.stations.toList(),
            itemAsString: (station) => station.stationNumber,
            selectedItem: authController.selectedStation.value,
            onChanged: (station) {
              if (station != null) {
                authController
                    .selectByNumber(station.stationNumber); // ← يحدث اسم المحطة
              }
              box.remove("stationNumber");
              box.write("stationNumber", station!.stationNumber);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "اختر رقم المحطة",
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
            popupProps: PopupProps.menu(showSearchBox: true),
          );
        }),
       
        Obx(() {
          if (authController.selectedStation.value == null) {
            return const SizedBox(); // يخفي العنصر تماماً
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [ const SizedBox(height: 16), Text("اسم المحطة",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownSearch<Station>(
                items: authController.stations.toList(),
                itemAsString: (station) => station.stationName,
                selectedItem: authController.selectedStation.value,
                enabled: false,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "اسم المحطة",
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
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xffEEEEEE)),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;

  const _CustomTextField({required this.label, required this.hint});

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
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
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

class _DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _DatePickerField({required this.label, required this.controller});

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
                controller.text = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
            decoration: InputDecoration(
              hintText: 'ادخل تاريخ الميلاد هنا',
              hintStyle: TextStyle(color: Color(0xff0000001A).withOpacity(.3)),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/images/Calendar.svg",
                  height: 20,
                  width: 20,
                  fit: BoxFit.fill,
                ),
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

class _DropDownField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const _DropDownField({
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
            hint: Text(
              hint ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0xff0000001A).withOpacity(.3),
                  fontWeight: FontWeight.w500,
                  fontFamily: "IBMPlexSansArabic"),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, textAlign: TextAlign.right),
                    ))
                .toList(),
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
}

class _CompanyPurposeStep extends StatefulWidget {
  const _CompanyPurposeStep({super.key});

  @override
  State<_CompanyPurposeStep> createState() => _CompanyPurposeStepState();
}

class _CompanyPurposeStepState extends State<_CompanyPurposeStep> {

  @override
  Widget build(BuildContext context) {
  return ListView(
  padding: const EdgeInsets.all(24),
  children: [
    // تفكيك العناصر من map باستخدام spread operator (...)
    ... authController.  questions.map((question) {
      // final items = {
      //   for (int i = 0; i < question.options.length; i++)
      //     'option$i': question.options[i],
      //   // if (question.options.contains("أخرى")) 'other': "Other:"
      // };
final items = {
  for (final option in question.options)
    option: option,
};

      return buildCard(
        title: question.text,
        items: items,
        onChanged: (selectedAnswers) {
          print(answersMap.toString());
          answersMap[question.id] = selectedAnswers;
          print("إجابات السؤال ${question.id}: $selectedAnswers");
          // مثال: answersMap[question.id] = selectedAnswers;
        },
      );
    }).toList(),

   
  ],
);

  }Widget buildCard({
  required String title,
  required Map<String, String> items,
  required Function(List<String>) onChanged,
}) {
  final checkedItems = <String, bool>{};
  final otherTextController = TextEditingController();

  items.forEach((key, _) => checkedItems[key] = false);

  return StatefulBuilder(
    builder: (context, setState) {
      void updateAnswers() {
        final selected = <String>[];

        checkedItems.forEach((key, value) {
          if (value) {
            if (key == 'أخرى') {
              selected.add(
                otherTextController.text.isNotEmpty
                    ? otherTextController.text
                    : 'أخرى',
              );
            } else {
              selected.add(key); // المفتاح = النص
            }
          }
        });

        onChanged(selected);
      }

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...items.entries.map((entry) {
                final isOther = entry.value == 'أخرى';

                return Column(
                  children: [
                    CheckboxListTile(
                      value: checkedItems[entry.value],
                      onChanged: (val) {
                        setState(() {
                          checkedItems[entry.value] = val!;
                        });
                        updateAnswers();
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(entry.value),
                    ),
                    if (isOther && checkedItems['أخرى'] == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: otherTextController,
                          onChanged: (_) => updateAnswers(),
                          decoration: const InputDecoration(
                            hintText: "اكتب هنا...",
                          ),
                        ),
                      ),
                  ],
                );
              }).toList()
            ],
          ),
        ),
      );
    },
  );
}

}

class _CompanyManagementStep extends StatefulWidget {
  const _CompanyManagementStep({Key? key}) : super(key: key);

  @override
  State<_CompanyManagementStep> createState() => _CompanyManagementStepState();
}

class _CompanyManagementStepState extends State<_CompanyManagementStep> {
  final TextEditingController birthDateController = TextEditingController();
  String? selectedNationality;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DC UPS نظام التغذية التيار",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      CheckboxListTile(
                        activeColor: AppColors.primaryColor,
                        value: upsChecks['upsCheck4'],
                        onChanged: (val) =>
                            setState(() => upsChecks['upsCheck4'] = val!),
                        title: const Text(
                            "فحص وصيانة كروت خاص بشاحن البطارية UPS والتأكد من تغذيتها لأجهزة الوحدة الطرفية\n707000026"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        activeColor: AppColors.primaryColor,
                        value: upsChecks['upsCheck1'],
                        onChanged: (val) =>
                            setState(() => upsChecks['upsCheck1'] = val!),
                        title: const Text("تحتاج استبدال UPS"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        activeColor: AppColors.primaryColor,
                        value: upsChecks['upsCheck2'],
                        onChanged: (val) =>
                            setState(() => upsChecks['upsCheck2'] = val!),
                        title: const Text("تم الاستبدال لـ UPS و 707000027"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        activeColor: AppColors.primaryColor,
                        value: upsChecks['upsCheck3'],
                        onChanged: (val) =>
                            setState(() => upsChecks['upsCheck3'] = val!),
                        title: const Text("UPS سليم"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        activeColor: AppColors.primaryColor,
                        value: upsChecks['otherUps'],
                        onChanged: (val) =>
                            setState(() => upsChecks['otherUps'] = val!),
                        title: Row(
                          children: [
                            const Text("Other: "),
                            if (upsChecks['otherUps']!)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        hintText: "اكتب هنا"),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    ]))),
        const SizedBox(height: 20),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("بطارية DC نظام التغذية التيار",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                buildRadio("battery1", "تركيب أو استبدال بطارية 707000040"),
                buildRadio("battery2", "تحتاج استبدال بطارية"),
                buildRadio("battery3", "البطارية سليمة"),
                buildRadio("other", "Other:"),
                if (batteryValue == "other")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: otherTextController,
                      decoration: const InputDecoration(hintText: "اكتب هنا"),
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildRadio(String value, String title) {
    return RadioListTile(
      activeColor: AppColors.primaryColor,
      value: value,
      groupValue: batteryValue,
      onChanged: (val) {
        setState(() {
          batteryValue = val!;
        });
      },
      title: Text(title),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _CompanyDecisionsStep extends StatefulWidget {
  const _CompanyDecisionsStep({super.key});

  @override
  State<_CompanyDecisionsStep> createState() => _CompanyDecisionsStepState();
}

class _CompanyDecisionsStepState extends State<_CompanyDecisionsStep> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("أنظمة التحكم (كروت التحكم)",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...[
                        // "تم فحص جميع الكروت للوحدة الأرضية\n707000033"
                        {
                          'key': 'checked0',
                          'label':
                              "تم فحص جميع الكروت للوحدة الأرضية\n707000033"
                        },
                        {'key': 'checked1', 'label': "جميع الكروت سليمة"},
                        {'key': 'checked2', 'label': "تحتاج استبدال كروت"},
                      ].map((item) => CheckboxListTile(
                            value: controlCardChecks[item['key']]!,
                            onChanged: (val) => setState(
                                () => controlCardChecks[item['key']!] = val!),
                            title: Text(item['label']!),
                            controlAffinity: ListTileControlAffinity.leading,
                          )),
                      CheckboxListTile(
                        value: controlCardChecks['other1'],
                        onChanged: (val) =>
                            setState(() => controlCardChecks['other1'] = val!),
                        title: Row(
                          children: [
                            const Text("Other: "),
                            if (controlCardChecks['other1']!)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextField(
                                    controller: other1TextController,
                                    decoration: const InputDecoration(
                                        hintText: "اكتب هنا"),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    ]))),
        const SizedBox(height: 20),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("أنظمة التحكم (برمجة)",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...[
                  {'key': 'prog1', 'label': "سليم"},
                  {
                    'key': 'prog2',
                    'label': "تم برمجة RTU و وحدة التحكم الطرفية\n707000038"
                  },
                  {'key': 'prog3', 'label': "لا يمكن البرمجة"},
                ].map((item) => CheckboxListTile(
                      value: programmingChecks[item['key']]!,
                      onChanged: (val) => setState(
                          () => programmingChecks[item['key']!] = val!),
                      title: Text(item['label']!),
                      controlAffinity: ListTileControlAffinity.leading,
                    )),
              ],
            ),
          ),
        )
      ],
    );
    ;
  }
}

class _ProfitLossDistributionStep extends StatefulWidget {
  const _ProfitLossDistributionStep({super.key});

  @override
  State<_ProfitLossDistributionStep> createState() =>
      _ProfitLossDistributionStepState();
}

class _ProfitLossDistributionStepState
    extends State<_ProfitLossDistributionStep> {
  final List<File> selectedImages = [];
  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    if (selectedImages.length >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only upload up to 9 images.")),
      );
      return;
    }
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final int fileSize = await file.length();
      if (fileSize <= 10 * 1024 * 1024) {
        setState(() {
          selectedImages.add(file);
        });
      } else {
        print("object");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File exceeds 10MB limit")),
        );
      }
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أنظمة التحكم (برمجة) قبل وبعد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload up to 5 supported files: image. Max 10 MB per file.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: showImageSourceDialog,
              icon: const Icon(
                Icons.upload_file,
                color: AppColors.primaryColor,
              ),
              label: const Text(
                'Add file',
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (selectedImages.isNotEmpty)
              ...selectedImages.map(
                (file) => ListTile(
                  title: Text(file.path.split('/').last),
                  subtitle: FutureBuilder<int>(
                    future: file.length(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final mb =
                            (snapshot.data! / (1024 * 1024)).toStringAsFixed(2);
                        return Text('$mb MB');
                      }
                      return Text('Loading...');
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        selectedImages.remove(file);
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: const Text('التالي',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
