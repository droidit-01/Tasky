// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/Screens/Home/home_screen.dart';
import 'package:tasky/User_Management/Login/controller/login_controller.dart';
import 'package:tasky/User_Management/Register/register_screen.dart';
import 'package:tasky/Services/theme_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          if (Get.currentRoute == LoginScreen()) {
            return true;
          }
          return false;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/login.png',
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Login to continue",
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome back! You have been missed.",
                      style: GoogleFonts.lato(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(() => TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: GoogleFonts.lato(color: Colors.grey),
                            errorText: controller.usernameError.value.isEmpty
                                ? null
                                : controller.usernameError.value,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF4e5ae8)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: GoogleFonts.lato(color: Colors.grey),
                            errorText: controller.passwordError.value.isEmpty
                                ? null
                                : controller.passwordError.value,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF4e5ae8)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.validateLogin()) {
                          controller.loginUser();

                          Get.to(() => const HomeScreen(),
                              transition: Transition.rightToLeftWithFade);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4e5ae8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Login",
                        style:
                            GoogleFonts.lato(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Get.to(() => RegisterScreen(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      child: Text(
                        "Don't have an account? Create one",
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
