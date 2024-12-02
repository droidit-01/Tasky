// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/Screens/Home/home_screen.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var usernameError = ''.obs;
  var passwordError = ''.obs;
  var emailError = ''.obs;
  var confirmPasswordError = ''.obs;

  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  bool validateLogin() {
    emailError.value = emailController.text.isEmpty ? "email is required" : '';
    passwordError.value =
        passwordController.text.isEmpty ? "Password is required" : '';

    return usernameError.value.isEmpty && passwordError.value.isEmpty;
  }

  saveData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    await storeUserDataInSharedPreferences(
      id: 1,
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      token: '',
      password: passwordController.text.trim(),
    );
    storeLoginStatusInSharedPreferences(true);
    Get.snackbar(
      "Success",
      "User registered successfully.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    const String loginUrl = "https://reqres.in/api/login";
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      print('Login Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          "Success",
          "User LoggedIn successfully. Token: ${data['token']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        storeLoginStatusInSharedPreferences(true);
        await storeUserDataInSharedPreferences(
          id: data['id'],
          email: emailController.text.trim(),
          token: data['token'],
          password: passwordController.text.trim(),
          username: usernameController.text.trim(),
        );

        Get.to(() => const HomeScreen(),
            transition: Transition.rightToLeftWithFade);
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          error["error"],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Unexpected error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to connect to the server. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeUserDataInSharedPreferences({
    required int id,
    required String username,
    required String email,
    required String token,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

  
    await prefs.setInt('id', id);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('token', token);
    await prefs.setString('password', password);
    print('User Data is Saved');
  }

  void storeLoginStatusInSharedPreferences(bool isLoggedIn) {
    final prefs = SharedPreferences.getInstance();
    prefs.then((sharedPrefs) {
      sharedPrefs.setBool('isLoggedIn', isLoggedIn);
    });
  }
}