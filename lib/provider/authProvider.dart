import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

User loggedInUser;

class AUthProvider with ChangeNotifier {
  final userRef = FirebaseDatabase.instance.reference().child('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<ResponseModel> login(String email, String password) async {
    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final dataSnapShot = await userRef.child(authResult.user.uid).once();
      loggedInUser = User(
          dataSnapShot.value['id'],
          dataSnapShot.value['fullname'],
          dataSnapShot.value['phoneNumber'],
          dataSnapShot.value['email'],
          "****************");
      return ResponseModel(true, "User SignIn Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> signUp(User user) async {
    try {
      final authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      await userRef.child(authResult.user.uid).set({
        "id": authResult.user.uid,
        "email": user.email,
        "fullname": user.fullName,
        "phoneNumber": user.phoneNumber
      });
      loggedInUser = new User(authResult.user.uid, user.fullName, user.fullName,
          user.email, user.password);
      return ResponseModel(true, "User SignUp Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> logOut() async {
    try {
      await firebaseAuth.signOut();
      loggedInUser = null;
      return ResponseModel(true, "User LogOut Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }
}
