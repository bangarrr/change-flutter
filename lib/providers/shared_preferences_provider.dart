import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// https://zenn.dev/riscait/books/flutter-riverpod-practical-introduction-archive/viewer/v0-shared-preferences
final localDbProvider = Provider<LocalDbUtility>((ref) {
  throw UnimplementedError();
});

const String userIdKey = 'change_user_id';

class LocalDbUtility {
  LocalDbUtility({required this.prefs});

  final SharedPreferences prefs;

  String? getUserID() {
    return prefs.getString(userIdKey);
  }

  void setUserId(String userId) {
    prefs.setString(userIdKey, userId);
  }
}