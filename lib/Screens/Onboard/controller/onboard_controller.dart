import 'package:get/get.dart';

class OnboardController extends GetxController {
  var currentPage = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/task.png",
      "title": "Organize Your Tasks",
      "description": "Easily manage and organize your daily tasks efficiently."
    },
    {
      "image": "assets/images/task.png",
      "title": "Set Reminders",
      "description": "Never forget your important deadlines and meetings."
    },
    {
      "image": "assets/images/task.png",
      "title": "Achieve Goals",
      "description": "Stay focused and achieve your long-term goals seamlessly."
    },
  ];

  void updatePage(int index) {
    currentPage.value = index;
  }
}
