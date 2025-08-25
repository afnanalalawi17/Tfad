import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tfad_app/model/QUESTION.dart';
import 'package:tfad_app/shared/appColor.dart';

import 'auth_controllers.dart';
import 'basic.dart';
import 'model/station.dart';

class MultiStepFormScreen extends StatefulWidget {
  const MultiStepFormScreen({super.key});

  @override
  State<MultiStepFormScreen> createState() => _MultiStepFormScreenState();
}

class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
  int currentStep = 0;
  final List<Widget> steps = [];
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    steps.addAll( [
      _PartnerDataStep(),
      _CompanyPurposeStep(), // (sample step powered by API too)
      _CompanyManagementStep(), // Step 3 (UPS/DC)
      _CompanyDecisionsStep(),  // Step 4 (RTU/AC)
      _ProfitLossDistributionStep(), // Step 5 (attachments)
    ]);
    // Load API data
    authController.loadInit();
  }

  bool _isSubmitting = false;

  Future<void> _nextStep() async {
    final isLastStep = currentStep == steps.length - 1;

    if (!isLastStep) {
      // لسنا في الخطوة الأخيرة → انتقلي للخطوة التالية فقط
      setState(() => currentStep++);
      return;
    }

    // نحن في الخطوة الأخيرة → أرسلي البيانات
    if (_isSubmitting) return; // منع ضغطات متكررة
    _isSubmitting = true;

    try {
      // تحقق سريع قبل الإرسال (اختياري)
      if (authController.selectedStation.value == null) {
        Get.snackbar('تنبيه', 'فضلاً اختاري المحطة قبل الإرسال');
        _isSubmitting = false;
        return;
      }

      // دايلوج تحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // عدّلي userId كما يلزمك
      final resp = await authController.submitReport(userId: 1);

      if (mounted) Navigator.of(context).pop(); // أغلق الدايلوج
      Get.snackbar('تم الإرسال', 'تم إنشاء التقرير بنجاح');
      Get.to( BasicView());

      // debugPrint(resp.toString());
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      Get.snackbar('فشل الإرسال', e.toString(), backgroundColor: Colors.red.shade50);
    } finally {
      _isSubmitting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / steps.length;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _HeaderSection(currentStep: currentStep, totalSteps: steps.length, progress: progress),
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

  const _HeaderSection({required this.currentStep, required this.totalSteps, required this.progress});

  String _titleForStep(int s) {
    switch (s) {
      case 0:
        return 'بيانات الفرقة والمحطة';
      case 1:
        return 'AC/DC أسئلة عامة من الـ API';
      case 2:
        return 'DC/UPS أنظمة التغذية (من الـ API)';
      case 3:
        return 'RTU/AC أنظمة التحكم (من الـ API)';
      case 4:
        return 'مرفقات قبل/بعد';
      default:
        return 'نموذج';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Get.back()),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(.15), borderRadius: BorderRadius.circular(8)),
            child: Text('${currentStep + 1}/$totalSteps', style: const TextStyle(fontSize: 14, color: AppColors.primaryColor)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(_titleForStep(currentStep), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        const SizedBox(height: 8),
        const Text('في حال فحص أو تركيب أي شيء لازم صورة قبل وبعد', style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 20),
        LinearProgressIndicator(minHeight: 20, borderRadius: BorderRadius.circular(20), value: progress, backgroundColor: AppColors.primaryColor.withOpacity(.1), color: AppColors.primaryColor),
      ]),
    );
  }
}

// ----------------------------- STEP 1 -----------------------------
class _PartnerDataStep extends StatefulWidget {
  const _PartnerDataStep();

  @override
  State<_PartnerDataStep> createState() => _PartnerDataStepState();
}

class _PartnerDataStepState extends State<_PartnerDataStep> {
  final TextEditingController birthDateController = TextEditingController();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(padding: const EdgeInsets.all(24), children: [
      // Technician name
      _LabeledReadOnlyField(label: 'اسم الفني', value: authController.technicianName.value),
      const SizedBox(height: 12),
      const Text('رقم المحطة', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      // داخل الـ UI
      Obx(() {
        return DropdownSearch<StationApi>(
          items: authController.stationsApi,                 // اسم القائمة في الكنترولر
          selectedItem: authController.selectedStation.value,
          itemAsString: (StationApi s) => s.stationNumber,   // كيف نعرض العنصر
          compareFn: (a, b) => a.id == b.id,              // مهم: يضمن تطابق selectedItem مع items
          onChanged: (StationApi? s) {
            if (s != null) authController.selectedStation.value = s;
          },

          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: 'اختر رقم المحطة',
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

          popupProps: PopupProps.menu(
            showSearchBox: true,
            emptyBuilder: (ctx, str) => const Center(child: Text('لا توجد محطات')),
            // optional: تنسيق العنصر داخل القائمة
            itemBuilder: (ctx, item, isSelected) => ListTile(
              title: Text(item.stationNumber),
              subtitle: Text(item.stationName),
              selected: isSelected,
            ),
          ),
        );
      })
,
      const SizedBox(height: 16),
      if (authController.selectedStation.value != null) ...[
        const Text('اسم المحطة', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownSearch<StationApi>(
          items: authController.stationsApi,
          itemAsString: (s) => s.stationName,
          selectedItem: authController.selectedStation.value,
          enabled: false,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: 'اسم المحطة',
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
            ),
          ),
        ),
      ],
      const SizedBox(height: 16),
      // _DatePickerField(label: 'تاريخ الميلاد', controller: birthDateController),
    ]));
  }
}

class _LabeledReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  const _LabeledReadOnlyField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        readOnly: true,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: value,
          hintStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
        ),
      ),
    ]);
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _DatePickerField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          hintText: 'ادخل التاريخ هنا',
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.string(
              // Simple inline calendar icon (replace with asset if you have)
              '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10h5v5H7z"/><path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v13c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 15H5V9h14v10z"/></svg>',
              height: 20,
              width: 20,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xffEEEEEE))),
        ),
      ),
    ]);
  }
}

// ----------------------------- STEP 2 (Generic from API) -----------------------------
class _CompanyPurposeStep extends StatelessWidget {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Example: show all questions as generic cards (checkbox or radio)
      final all = authController.questionsApi;
      if (all.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('جارِ تحميل الأسئلة...')));
      }
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('أسئلة عامة من الـ API (عرض تجريبي)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...all.map((q) => QuestionCard(question: q)).toList(),
        ],
      );
    });
  }
}

// ----------------------------- STEP 3 (DC/UPS from API) -----------------------------
class _CompanyManagementStep extends StatelessWidget {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If API adds group field, prefer: q.group == 'dc' / 'ups'
      final dcQs = authController.questionsApi.where((q) => q.text.contains('DC')).toList();
      final upsQs = authController.questionsApi.where((q) => q.text.contains('UPS')).toList();

      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (dcQs.isNotEmpty) const Text('DC نظام التغذية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...dcQs.map((q) => QuestionCard(question: q)),
          const SizedBox(height: 12),
          if (upsQs.isNotEmpty) const Text('UPS نظام التغذية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...upsQs.map((q) => QuestionCard(question: q)),
        ],
      );
    });
  }
}

// ----------------------------- STEP 4 (RTU/AC from API) -----------------------------
class _CompanyDecisionsStep extends StatelessWidget {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rtuQs = authController.questionsApi.where((q) => q.text.contains('RTU')).toList();
      final acQs = authController.questionsApi.where((q) => q.text.contains('AC')).toList();
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (rtuQs.isNotEmpty) const Text('RTU أنظمة التحكم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...rtuQs.map((q) => QuestionCard(question: q)),
          const SizedBox(height: 12),
          if (acQs.isNotEmpty) const Text('AC نظام الفيوزات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...acQs.map((q) => QuestionCard(question: q)),
        ],
      );
    });
  }
}

// ----------------------------- STEP 5 (Attachments) -----------------------------
class _ProfitLossDistributionStep extends StatefulWidget {
  const _ProfitLossDistributionStep({super.key});
  @override
  State<_ProfitLossDistributionStep> createState() => _ProfitLossDistributionStepState();
}

class _ProfitLossDistributionStepState extends State<_ProfitLossDistributionStep> {
  final picker = ImagePicker();
  final authController = Get.put(AuthController());

  Future<void> pickImage(ImageSource source) async {
    if (authController.   selectedImages.length >= 9) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يمكن رفع 9 صور كحد أقصى')));
      return;
    }
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final int fileSize = await file.length();
      if (fileSize <= 10 * 1024 * 1024) {
        setState(() =>authController. selectedImages.add(file));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حجم الملف يتجاوز 10MB')));
      }
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () { Navigator.pop(context); pickImage(ImageSource.camera); }),
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { Navigator.pop(context); pickImage(ImageSource.gallery); }),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8),
          const Text('أنظمة التحكم (برمجة) قبل/بعد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Upload up to 9 images. Max 10 MB per file.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: showImageSourceDialog,
            icon: const Icon(Icons.upload_file, color: AppColors.primaryColor),
            label: const Text('Add file', style: TextStyle(color: AppColors.primaryColor)),
          ),
          const SizedBox(height: 10),
          if (authController.selectedImages.isNotEmpty)
            ...authController.selectedImages.map((file) => ListTile(
              title: Text(file.path.split('/').last),
              subtitle: FutureBuilder<int>(
                future: file.length(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    final mb = (snap.data! / (1024 * 1024)).toStringAsFixed(2);
                    return Text('$mb MB');
                  }
                  return const Text('Loading...');
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => authController.selectedImages.remove(file)),
              ),
            )),
        ]),
      ),
    );
  }
}

// ----------------------------- REUSABLE QUESTION CARD -----------------------------
class QuestionCard extends StatefulWidget {
  final QuestionApi question;
  const QuestionCard({super.key, required this.question});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  final Map<String, bool> _checked = {};
  String? _selectedRadio;
  final _otherCtrl = TextEditingController();
  final authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    for (final o in widget.question.options) {
      _checked[o] = false;
    }
    // restore previous answer if exists
    final prev = authController.answersMap[widget.question.id];
    if (prev is List<String>) {
      for (final k in _checked.keys) {
        _checked[k] = prev.contains(k) || (k == 'أخرى' && prev.contains(_otherCtrl.text));
      }
    } else if (prev is String) {
      _selectedRadio = prev;
    }
  }

  void _persistAnswer() {
    if (widget.question.type == 'checkbox') {
      final selected = <String>[];
      _checked.forEach((opt, v) {
        if (v) {
          if (opt == 'أخرى') {
            selected.add(_otherCtrl.text.isNotEmpty ? _otherCtrl.text : 'أخرى');
          } else {
            selected.add(opt);
          }
        }
      });
      authController.answersMap[widget.question.id] = selected;
    } else {
      authController.answersMap[widget.question.id] = _selectedRadio ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final isCheckbox = q.type.toLowerCase() == 'checkbox';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (q.serialNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('SN: ${q.serialNumber}', style: const TextStyle(color: Colors.grey)),
          ],
          const SizedBox(height: 8),

          if (isCheckbox)
            ...q.options.map((opt) {
              final isOther = opt == 'أخرى';
              return Column(children: [
                CheckboxListTile(
                  value: _checked[opt] ?? false,
                  onChanged: (v) {
                    setState(() => _checked[opt] = v ?? false);
                    _persistAnswer();
                  },
                  title: Text(opt),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryColor,
                ),
                if (isOther && (_checked['أخرى'] ?? false))
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: TextField(
                      controller: _otherCtrl,
                      decoration: const InputDecoration(hintText: 'اكتب هنا...'),
                      onChanged: (_) => _persistAnswer(),
                    ),
                  ),
              ]);
            }),

          if (!isCheckbox)
            ...q.options.map((opt) {
              final isOther = opt == 'أخرى';
              return Column(children: [
                RadioListTile<String>(
                  value: opt,
                  groupValue: _selectedRadio,
                  onChanged: (v) {
                    setState(() => _selectedRadio = v);
                    _persistAnswer();
                  },
                  title: Text(opt),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryColor,
                ),
                if (isOther && _selectedRadio == 'أخرى')
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: TextField(
                      controller: _otherCtrl,
                      decoration: const InputDecoration(hintText: 'اكتب هنا...'),
                      onChanged: (_) => _persistAnswer(),
                    ),
                  ),
              ]);
            }),
        ]),
      ),
    );
  }
}

// ----------------------------- NEXT BUTTON -----------------------------
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
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onTap,
          child: const Text('التالي', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
