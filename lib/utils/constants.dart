import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:flutter/material.dart';

class Constant {
  static Size getAppSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size;
  }

  static String stringValidator(String value, String controllerName) {
    if (value.isEmpty) {
      return "$controllerName cannot be empty";
    }
    return null;
  }

  static showFialureDialogue(String message, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Something went wrong",
              style: AppTextStyles.appTextStyle,
            ),
            content: Text(
              message,
              style: AppTextStyles.redlabelTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static showSuccessDialogue(String message, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Operation Sucessfull",
              style: AppTextStyles.appTextStyle,
            ),
            content: Text(
              message,
              style: AppTextStyles.greenlabelTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static Widget circularInidcator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Constant.primaryColorDark,
      ),
    );
  }

  static Color primaryColorDark = Color(0xff0d1724);
  static Color primaryColorLight = Colors.white;

  static final String baseSearchUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static final String apiKey = 'AIzaSyCDJa_D_Ewcm8wE8OAH6uBQttSxALdoNUI';
  static final String dispatchPendingStatus = "penidng";
  static final String dispatchActiveStatus = "active";
  static final String dispatchCompletedStatus = "completed";
  static final String dispatchTypeEconomy = "Economy";
  static final String dispatchTypeExpress = "Express";
  static final String dispatchTypePremiun = "Premiun";
  static final double dispatchBaseFare = 500.00;
  static final String dispatchPickIpAddress = "18 Mushin Avenue Lagos";
  static final String dispatchDestinationAddress = "22 Yaba Education Centre";
  static final String pickUp = "PickUp Address";
  static final String deliveryAddress = "Delivery Address";
}
