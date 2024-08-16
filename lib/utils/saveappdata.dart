import 'package:shared_preferences/shared_preferences.dart';

class SaveAppData{

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<void> saveflag(String response) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('flag', response);
}

Future<void> saveUserCategorykey(String response) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('usercategorykey', response);
}

Future<String?> get getToken async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String?> getFlag() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('flag');
}

Future<String?> getUserCategoryKey() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('usercategorykey');
}


Future<void> save_flag_type(String flag) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('flag', flag);
}

Future<String?> get get_flag_type async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('flag');
}


}