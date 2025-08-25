import 'package:flutter/material.dart';
import 'package:tfad_app/multiStep.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:intl/intl.dart';
import 'package:tfad_app/shared/mainButton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("محمد عمر ", style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                  Image.asset(
                    "assets/images/Artboard 1.png",
                    height: 50,
                    width: 50,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.7),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.7),
                              borderRadius: BorderRadius.circular(5)),
                          child: Icon(Icons.calendar_month_sharp,
                              color: Colors.white))
                    ],
                  ),
                ),
              ),SizedBox(height: 10,),
               Container(
  padding: EdgeInsets.all(22), // Adds padding around the container
  decoration: BoxDecoration(
    color: AppColors.primaryColor.withOpacity(.7), // Sets the background color of the container
   borderRadius: BorderRadius.circular(5)
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children with space between them
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns the column's children to the left
        children: [
          Row(
            children: [
              Icon(
                Icons.task_rounded, // QR scanner icon
                size: 30.0,
                color: Colors.white, // Sets icon color to white
              ),
              SizedBox(
                width: 10, // Adds space between icon and text
              ),
              Text(
                'المهام', // Text: "Permits"
                style: TextStyle(
                  color: Colors.white, // Sets text color to white
                  fontSize: 20, // Font size for the text
                  fontWeight: FontWeight.w600, // Semi-bold text
                ),
              ),
            ],
          ),
          SizedBox(
            height:10, // Adds vertical spacing
          ),
          Container(
            child: Text(
              'عدد المهام التي تمت \nبواسطة المستخدم', // Text explaining the permit count
              textAlign: TextAlign.center, // Centers the text
              style: TextStyle(
                color:  Colors.white, // Sets text color to white
                fontSize: 11, // Small font size
                fontWeight: FontWeight.bold, // Light font weight
              ),
            ),
          ),
          SizedBox(
            height: 10, // Adds vertical spacing
          ),
          Text(
            "34" + '   مهمة', // Displays the permit count
            textAlign: TextAlign.center, // Centers the text
            style: TextStyle(
              color:  Colors.white, // Sets text color to white
              fontSize: 14, // Font size for the permit count
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
          SizedBox(
            height: 20, // Adds vertical spacing
          ),
          GestureDetector(
            onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MultiStepFormScreen()));
            },
            child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryColor, // White color for the button
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
                  children: [
                    Text(
                      'تسجيل', // Button text: "Confirm Permit"
                      style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold), // Text color
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined, // Icon for button
                      size: 15,
                      color:  Colors.white, // Icon color
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      Image.asset(
        'assets/images/img2 2.png' // Image asset to display on the right side
      ),
    ],
  ),
),

              
            ]),
          ),
        ));
  }
}
