import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print("Error during logout: $error");
    }
  }
}
