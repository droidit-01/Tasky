import 'package:get/get.dart';
import 'package:tasky/Services/theme.dart';

class TaskTileController extends GetxController {
  getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishclr;
      case 1:
        return pinkclr;
      case 2:
        return yellowclr;
    }
  }
}
