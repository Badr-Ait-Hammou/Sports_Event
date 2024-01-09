import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print("Error during logout: $error");
    }
  }


  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
        Map<String, dynamic> userInfo = userDoc.data() as Map<String, dynamic>;

        return userInfo;
      } else {
        print("User not logged in");
        return {};
      }
    } catch (error) {
      print("Error getting user info: $error");
      return {};
    }
  }

  Future<void> updateUserProfile(String firstName, String lastName) async {
    try {
      User? user = _auth.currentUser;
      String userId = user?.uid ?? '';

      await _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
      });
    } catch (error) {
      print("Error updating user profile: $error");
    }
  }


  Future<Map<String, dynamic>> getUserInfoById(String userId) async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();
      return userDoc.data() as Map<String, dynamic>;
    } catch (error) {
      print("Error getting user info by ID: $error");
      return {};
    }
  }
}
