import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/Screens/Onboard/onboard_screen.dart';
import 'package:tasky/Screens/Home/home_screen.dart';
import 'package:tasky/User_Management/Login/login_screen.dart';
import 'package:tasky/Services/theme_controller.dart';
import 'package:tasky/db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('en', null);

  await Get.putAsync(() async => SharedPreferences.getInstance());
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

//Developed by : Jay Vekariya

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Tasky',
        debugShowCheckedModeBanner: false,
        theme: themeController.isDarkMode.value
            ? ThemeData.dark()
            : ThemeData.light(),
        home: OnboardScreen(),
        initialRoute: isLoggedIn ? '/home' : '/onboard',
        getPages: [
          GetPage(
            name: '/onboard',
            page: () => OnboardScreen(),
          ),
          GetPage(
            name: '/home',
            page: () => const HomeScreen(),
          ),
          GetPage(
            name: '/login',
            page: () => LoginScreen(),
          ),
        ],
      ),
    );
  }
}
