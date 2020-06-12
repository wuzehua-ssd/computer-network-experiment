import 'package:shared_preferences/shared_preferences.dart';

// 获取缓存
setStorage(key, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

// 保存缓存
Future<String> getStorage(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? "";
}
