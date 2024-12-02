// ignore_for_file: avoid_print, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:tasky/Screens/Home/controller/home_controller.dart';
import 'package:tasky/Screens/Task/add_task_screen.dart';
import 'package:tasky/Screens/Task_Tile/task_tile.dart';
import 'package:tasky/User_Management/Profile/profile_screen.dart';
import 'package:tasky/Services/theme_controller.dart';
import 'package:tasky/Controllers/task_controller.dart';
import 'package:tasky/Model/task.dart';
import 'package:tasky/Services/theme.dart';
import 'package:tasky/Widgets/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = Get.put(TaskController());
  final controller = Get.put(HomeController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        taskController.getTasks();
        return WillPopScope(
          onWillPop: () async {
            if (Get.currentRoute == const HomeScreen()) {
              return true;
            }
            return false;
          },
          child: Scaffold(
            appBar: appBar(),
            backgroundColor: context.theme.colorScheme.surface,
            body: Column(
              children: [
                addTaskBar(),
                addDateBar(),
                const SizedBox(height: 10),
                showTasks(),
              ],
            ),
          ),
        );
      },
    );
  }

  showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = taskController.taskList[index];
              print(task.toJson());

              if (task.title != null) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.date ==
                  DateFormat.yMd().format(controller.selectedDate.value)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.27
            : MediaQuery.of(context).size.height * 0.36,
        width: Get.width,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Get.isDarkMode ? darkGreyclr : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryclr,
                    context: context,
                  ),
            bottomSheetButton(
              label: "Task Update",
              onTap: () {
                showUpdateDialog(context, task);
              },
              clr: const Color(0xFFF1BB1A),
              context: context,
            ),
            bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[500]!,
              context: context,
            ),
            const SizedBox(height: 20),
            bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void showUpdateDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final noteController = TextEditingController(text: task.note);
    final priority = task.priority.obs;
    final status = task.status.obs;
    final dueDate = DateFormat('MM/dd/yyyy').parse(task.date.toString()).obs;
    final dateController = TextEditingController(text: dueDate.toString());

    Get.dialog(
      AlertDialog(
        title: const Text("Update Task"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: "Note",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Due date",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('MM/dd/yyyy').format(pickedDate);
                    dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: priority.value,
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
                items: ["High", "Medium", "Low"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  priority.value = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status.value,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: ["To-Do", "In Progress", "Completed"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  status.value = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.lato(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4e5ae8),
            ),
            onPressed: () {
              Task updatedTask = Task(
                id: task.id,
                title: titleController.text,
                note: noteController.text,
                date: DateFormat('MM/dd/yyyy').format(dueDate.value),
                priority: priority.value,
                status: status.value,
                assignedUser: task.assignedUser,
                color: task.color,
                isCompleted: task.isCompleted,
              );

              taskController.updateTask(updatedTask);
              Get.back();
            },
            child: Text(
              "Update",
              style: GoogleFonts.lato(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryclr,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            controller.selectedDate.value = date;
          });
        },
      ),
    );
  }

  addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                taskController.getTasks();
              }),
        ],
      ),
    );
  }

  appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          themeController.toggleTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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
}
