import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var isLoaded = false.obs;

  final userName = ''.obs;
  final emailName = ''.obs;
  final passwords = ''.obs;
  final tokenName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    isLoaded.value = true;
    getUserDataFromSharedPreferences();
  }

  Future<Map<String, String>> getUserDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final username = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';
    final token = prefs.getString('token') ?? '';
    final password = prefs.getString('password') ?? '';
    userName.value = username;
    emailName.value = email;
    tokenName.value = token;
    passwords.value = password;
    return {
      'username': username,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/onboard');
  }
}
