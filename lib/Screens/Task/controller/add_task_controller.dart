// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTaskController extends GetxController {
  static AddTaskController get instance => Get.find();

  String endTime = "9:30 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int selectedColor = 0;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedPriority = "High".obs;
  final selectedStatus = "To-Do".obs;
  final selectedUser = Rxn<String>();

  var users = <String>[].obs;
  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    const String apiUrl = 'https://reqres.in/api/users?page=1&per_page=150';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final userList = responseData['data'] as List<dynamic>;
        users.value = userList
            .map((user) => "${user['first_name']} ${user['last_name']}")
            .toList();
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch users. Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while fetching users. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTask() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        "Error",
        "Please fill all the required fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    const String apiUrl = "https://jsonplaceholder.typicode.com/todos";
    final body = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "dueDate": selectedDate.value.toIso8601String(),
      "priority": selectedPriority.value,
      "status": selectedStatus.value,
      "assignedUser": selectedUser.value,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          "Success",
          "Task created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print("Response: $responseData");
      } else {
        Get.snackbar(
          "Error",
          "Failed to create task. Try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Error: ${response.body}");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to connect to the server.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
