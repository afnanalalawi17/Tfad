import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfad_app/editProfile.dart';
import 'package:tfad_app/homeScreen.dart';
import 'package:tfad_app/notfication.dart';
import 'package:tfad_app/settings.dart';
import 'package:tfad_app/shared/appColor.dart';
import 'package:tfad_app/shared/basic_controllers.dart';
// This is the main class for BasicView which holds the layout for tabs
class BasicView extends StatelessWidget {
  // Controllers for managing data and state
  final basicController = Get.put(BasicController());

  @override
  Widget build(BuildContext context) {var heightApp = MediaQuery.of(context).size.height;
    var widthApp = MediaQuery.of(context).size.width;
    return GetBuilder<BasicController>(builder: (controller) {
      return Scaffold(
        extendBody: true, // Extends body behind the bottom navigation bar
        backgroundColor: Colors.white, // Background color for the scaffold
        body: IndexedStack(
          // This is used to show the view for the selected tab
          index: controller.tabIndex,
          children: [
            NotificationsScreen(), // First tab content (Notification View)
            HomeScreen(), // Second tab content (Home View)
            SettingsScreen(), // Third tab content (Settings View)
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          // Bottom navigation bar with gradient
          color: Colors.white,
          backgroundColor: AppColors.primaryColor, // Background color for app bar
          height: 60, // Height of the bottom navigation bar
          initialActiveIndex: controller.tabIndex, // Set the initial active tab
          disableDefaultTabController: true, // Disable default tab controller behavior
          items: [
            // First tab item - Notification tab
            TabItem(
                icon: Icons.notifications,
                title: 'الإشعارات'),
            // Second tab item - Home tab
            TabItem(icon: Icons.home, title: 'الرئيسية'),
            // Third tab item - Settings tab
            TabItem(icon: Icons.settings, title: 'الإعدادات'),
          ],
          // Tab item onTap functionality
          onTap: controller.changeTabIndex,
        ),
      );
    });
  }
}
