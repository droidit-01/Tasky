// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Screens/Task/controller/add_task_controller.dart';
import 'package:tasky/User_Management/Profile/profile_screen.dart';
import 'package:tasky/Controllers/task_controller.dart';
import 'package:tasky/Services/theme.dart';
import 'package:tasky/Widgets/button.dart';
import 'package:tasky/Widgets/input_field.dart';

import '../../Model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final taskController = Get.put(TaskController());
  final controller = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTaskController>(
      init: AddTaskController(),
      builder: (controller) => Scaffold(
        appBar: appBar(context),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Task",
                    style: headingStyle,
                  ),
                  MyInputField(
                      title: "Title",
                      hint: "Enter Your Title",
                      controller: controller.titleController),
                  MyInputField(
                      title: "Description",
                      hint: "Enter Your Description",
                      controller: controller.descriptionController),
                  MyInputField(
                    title: "Due Date",
                    hint:
                        DateFormat.yMd().format(controller.selectedDate.value),
                    widget: IconButton(
                      onPressed: () {
                        getDateFromUser();
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  MyInputField(
                    title: "Priority",
                    hint: controller.selectedPriority.value,
                    widget: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      items: ["High", "Medium", "Low"]
                          .map((priority) => DropdownMenuItem(
                              value: priority, child: Text(priority)))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          controller.selectedPriority.value = value!;
                        });
                      },
                    ),
                  ),
                  MyInputField(
                    title: "Status",
                    hint: controller.selectedStatus.value,
                    widget: DropdownButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: subTitleStyle,
                      items: ["To-Do", "In Progress", "Done"]
                          .map((status) => DropdownMenuItem(
                              value: status, child: Text(status)))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          controller.selectedStatus.value = value!;
                        });
                      },
                    ),
                  ),
                  Obx(
                    () => MyInputField(
                      title: "Assigned User",
                      hint: controller.selectedUser.value ?? "Select a user",
                      widget: Obx(() {
                        if (controller.isLoading.value) {
                          return const CircularProgressIndicator();
                        }

                        if (controller.users.isEmpty) {
                          return const Text("No users available");
                        }

                        return DropdownButton<String>(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          style: subTitleStyle,
                          items: controller.users
                              .map((user) => DropdownMenuItem(
                                  value: user, child: Text(user)))
                              .toList(),
                          onChanged: (String? value) {
                            controller.selectedUser.value = value!;
                          },
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      colorPallete(),
                      MyButton(
                          label: "Create Task", onTap: () => validateDate()),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateDate() {
    if (controller.titleController.text.isNotEmpty &&
        controller.descriptionController.text.isNotEmpty) {
      addTaskToDb();
      controller.createTask();
      Get.back();
    } else if (controller.titleController.text.isEmpty ||
        controller.descriptionController.text.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          "Required",
          style: TextStyle(color: Colors.red),
        ),
        messageText: const Text(
          "All fields are required !",
          style: TextStyle(color: Colors.red),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  addTaskToDb() async {
    var value = await taskController.addTask(
      task: Task(
        note: controller.titleController.text,
        title: controller.descriptionController.text,
        date: DateFormat.yMd().format(controller.selectedDate.value),
        priority: controller.selectedPriority.value,
        status: controller.selectedStatus.value,
        assignedUser: controller.selectedUser.value,
        color: controller.selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
  }

  colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    controller.selectedColor = index;
                    print("$index");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryclr
                        : index == 1
                            ? pinkclr
                            : yellowclr,
                    child: controller.selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.surface,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            Get.to(() => ProfileScreen(),
                transition: Transition.rightToLeftWithFade);
          },
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.png'),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2121),
    );
    if (pickerDate != null) {
      setState(() {
        controller.selectedDate.value = pickerDate;
        print(controller.selectedDate);
      });
    } else {
      print("it's null or something is wrong");
    }
  }
}
