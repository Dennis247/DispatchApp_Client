import 'dart:convert';

import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/model/user.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

User loggedInUser;

class AUthProvider with ChangeNotifier {
  final userRef = FirebaseDatabase.instance.reference().child('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoggedIn = false;
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
          password);
      storeAutoData(loggedInUser);
      storeAppOnBoardingData(loggedInUser.id);
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
      final autoLoggedUser = User(authResult.user.uid, user.email,
          user.fullName, user.phoneNumber, user.password);
      storeAutoData(autoLoggedUser);
      storeAppOnBoardingData(loggedInUser.id);
      return ResponseModel(true, "User SignUp Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> logOut() async {
    try {
      await firebaseAuth.signOut();
      loggedInUser = null;
      deleteAutoData();
      return ResponseModel(true, "User LogOut Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> updateProfile(
      String fullname, String phoneNumber) async {
    try {
      userRef
          .child(loggedInUser.id)
          .update({'fullname': fullname, 'phoneNumber': phoneNumber});
      loggedInUser = User(loggedInUser.id, fullname, phoneNumber,
          loggedInUser.email, loggedInUser.password);
      return ResponseModel(true, "User Profile Updated Sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> updatePassword(String password) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.updatePassword(password);
      return ResponseModel(true, "Password Update Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  void storeAutoData(User user) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final logOnData = json.encode({
      'id': user.id,
      'fullName': user.fullName,
      'password': user.password,
      'email': user.email,
      'phoneNumber': user.phoneNumber
    });
    sharedPrefs.setString(Constant.autoLogOnData, logOnData);
  }

  void storeAppOnBoardingData(String userId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final logOnData = json.encode({
      'id': userId,
    });
    sharedPrefs.setString(Constant.onBoardingData, logOnData);
  }

  void deleteAutoData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Constant.autoLogOnData);
  }

  Future<bool> tryAutoLogin() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey(Constant.autoLogOnData)) {
      return false;
    }
    final sharedData = sharedPref.getString(Constant.autoLogOnData);
    final logOnData = json.decode(sharedData) as Map<String, Object>;
    loggedInUser = new User(logOnData['id'], logOnData['fullName'],
        logOnData['phoneNumber'], logOnData['email'], logOnData['password']);
    isLoggedIn = true;
    return true;
  }

  Future<bool> isUserOnBoarded() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey(Constant.onBoardingData)) {
      return false;
    }

    return true;
  }
}
