import 'package:flutter/material.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:tfad_app/shared/mainButton.dart';
import 'package:tfad_app/shared/textField.dart';


class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final TextEditingController phoneController = TextEditingController();
  String? selectedNationality;

  @override
  Widget build(BuildContext context) {var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الحساب',style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold  ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
       leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=4'), // صورتك من النت
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            size: 20, color: Colors.white),
                        onPressed: () {
                          // TODO: تغيير صورة البروفايل
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // حقل اسم المستخدم
            CustomTextField(
              label: 'اسم المستخدم',
              hint: "ادخل اسم المستخدم (اختياري)",
              icon: "assets/images/Profile.svg",
            ),  Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("رقم الجوال", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
         CustomPhoneField(
              phoneController: phoneController,
  onChanged: (value) {
    print('رقم الجوال كامل: $value');
  },
)
,      ],
            ),
    
           
            const Spacer(),

            MainButton(
              title: 'حفظ التعديلات',
              onPressed: () {                          
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsProfileScreen()));

                // TODO: احفظ التغييرات هنا
              },
            )
          ],
        ),
      ),
    );
  }
}
