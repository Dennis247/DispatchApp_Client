import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AUthProvider with ChangeNotifier {
  final userRef = FirebaseDatabase.instance.reference().child('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<ResponseModel> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
        "email": user.email,
        "fullname": user.fullName,
        "phoneNumber": user.phoneNumber
      });
      return ResponseModel(true, "User SignUp Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }
}
