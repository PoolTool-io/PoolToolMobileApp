import 'package:flutter/foundation.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserIdPreference {
  Future<String> getUserId() async {
    if (!kReleaseMode) {
      return "mobile-app-test-user";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var existingUserId = prefs.getString(Constants.USER_ID);
    if (existingUserId == null) {
      existingUserId = const Uuid().v4();
      prefs.setString(Constants.USER_ID, existingUserId);
    }
    return existingUserId;
  }
}
