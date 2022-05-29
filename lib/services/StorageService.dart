import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  loginStatus(status, token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("status", status);
    pref.setString("token", token);
  }

  getLoginToken() async {
    final pref = await SharedPreferences.getInstance();
    final status = pref.getString("token");
    return status;
  }

  getLoginStatus() async {
    final pref = await SharedPreferences.getInstance();
    final status = pref.getBool("status");
    return status;
  }
}
