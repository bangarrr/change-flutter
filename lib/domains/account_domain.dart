import 'package:change/providers/shared_preferences_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDomain {
  LocalDbUtility localDB;
  static final _auth = FirebaseAuth.instance;

  AccountDomain({required this.localDB});

  Future<void> createAccount(Map<String, dynamic> formValues) async {
    final response = await FirebaseFunctions
        .instanceFor(region: 'asia-northeast1')
        .httpsCallable('registUser')
        .call(formValues);
    localDB.setUserId(response.data["userID"]);
  }

  Future<void> handleLogin() async {
    final userID = localDB.getUserID();
    final response = await FirebaseFunctions
        .instanceFor(region: 'asia-northeast1')
        .httpsCallable('createLoginToken')
        .call({ 'userID': userID });
    await _auth.signInWithCustomToken(response.data["token"]);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  bool isRegistered() {
    print(localDB.getUserID());
    return localDB.getUserID() != null;
  }
}