import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/User_Management/Register/controller/register_controller.dart';
import 'package:tasky/Services/theme_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/register.png',
                    height: 300,
                  ),
                  Text(
                    "Create an Account",
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please enter valid details for Registration.",
                    style: GoogleFonts.lato(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(() => TextField(
                        controller: controller.usernameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: "Username",
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
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          errorText: controller.emailError.value.isEmpty
                              ? null
                              : controller.emailError.value,
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
                  const SizedBox(height: 20),
                  Obx(() => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          errorText:
                              controller.confirmPasswordError.value.isEmpty
                                  ? null
                                  : controller.confirmPasswordError.value,
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
                      if (controller.validateRegister()) {
                        controller.registerUser();
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
                      "Register",
                      style:
                          GoogleFonts.lato(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Already have an account? Login",
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
    );
  }
}
