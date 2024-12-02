import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/Screens/Onboard/controller/onboard_controller.dart';
import 'package:tasky/User_Management/Login/login_screen.dart';
import 'package:tasky/Services/theme_controller.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});
  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardController>(
      init: OnboardController(),
      builder: (controller) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: controller.updatePage,
                itemCount: controller.onboardingData.length,
                itemBuilder: (context, index) {
                  final data = controller.onboardingData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: Image.asset(
                          data['image']!,
                          key: ValueKey(data['image']),
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 20),
                   
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: Text(
                          data['title']!,
                          key: ValueKey(data['title']),
                          style: GoogleFonts.lato(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
        
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: Padding(
                          key: ValueKey(data['description']),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            data['description']!,
                            style: GoogleFonts.lato(
                                fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: controller.currentPage.value == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? const Color(0xFF4e5ae8)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => controller.currentPage.value ==
                      controller.onboardingData.length - 1
                  ? SizedBox(
                      height: 55,
                      width: Get.width * .42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: const Color(0xFF4e5ae8),
                        ),
                        onPressed: () {
                          Get.to(() => LoginScreen(),
                              transition: Transition.rightToLeftWithFade);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_circle_right,
                              color: Colors.white,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        controller
                            .updatePage(controller.onboardingData.length - 1);
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
