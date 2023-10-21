import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/network/auth/auth_client.dart';
import 'package:pegasus_tool/network/dio_factory.dart';
import 'package:pegasus_tool/services/firebase_app_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';

class FirebaseAuthService {
  late FirebaseAuth firebaseAuth;

  FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();
  FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  final StreamController<bool> _isLoggedInStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoggedInStream => _isLoggedInStreamController.stream;

  FirebaseAuthService() {
    FirebaseApp firebaseApp = GetIt.I<FirebaseAppService>().firebaseApp;
    firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  }

  bool get isLoggedIn => firebaseAuth.currentUser != null;

  Future<bool> login(LoginRequest loginRequest) async {
    AuthClient authClient = AuthClient(getDio());
    LoginResponse loginResponse = await authClient.login(loginRequest);
    UserCredential userCredential =
        await firebaseAuth.signInWithCustomToken(loginResponse.token);
    if (isLoggedIn) {
      String? token = await firebaseMessagingService.getToken();
      await firebaseDatabaseService.firebaseDatabase
          .ref()
          .child(
              "${Environment.getEnvironment()}/users/auth/${userCredential.user!.uid}/gcm_token")
          .set(token);
    }
    _isLoggedInStreamController.add(isLoggedIn);
    return isLoggedIn;
  }

  void logout() async {
    await firebaseAuth.signOut();
    _isLoggedInStreamController.add(false);
  }
}
