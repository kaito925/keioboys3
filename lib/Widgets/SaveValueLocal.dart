import 'package:shared_preferences/shared_preferences.dart';

Future<int> getValueLocal({path}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(path);
}

void saveValueLocal({String path, int value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(path, value);
}
