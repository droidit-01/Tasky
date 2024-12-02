import 'package:get/get.dart';
import 'package:tasky/Model/task.dart';
import 'package:tasky/db/db_helper.dart';

class HomeController extends GetxController {
  var selectedDate = DateTime.now().obs;

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  var isLoading = false.obs;

  var taskList = <Task>[].obs;

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
}
