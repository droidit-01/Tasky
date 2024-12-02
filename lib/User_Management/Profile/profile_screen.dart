import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/User_Management/Profile/controller/profile_controller.dart';
import 'package:tasky/Services/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ThemeController themeController = Get.find<ThemeController>();
  final controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) => Scaffold(
        backgroundColor:
            themeController.isDarkMode.value ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor:
              themeController.isDarkMode.value ? Colors.black : Colors.white,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.lato(fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return Center(
            child: AnimatedOpacity(
              opacity: controller.isLoaded.value ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: controller.isLoaded.value ? 150 : 100,
                      width: controller.isLoaded.value ? 150 : 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/person.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.userName.value,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.emailName.value,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.passwords.value,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        "Edit Profile",
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF573EF6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ListTile(
                      title: Text(
                        'Dark theme',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: Obx(
                        () => Switch(
                          value: themeController.isDarkMode.value,
                          onChanged: (value) {
                            themeController.toggleTheme();
                          },
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade200),
                    ListTile(
                      onTap: () {
                        logoutDialog();
                      },
                      title: Text(
                        'LogOut',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Divider(color: Colors.grey.shade200),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void logoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.lato(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              controller.logout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.lato(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
