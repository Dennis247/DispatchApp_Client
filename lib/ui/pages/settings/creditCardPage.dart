import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:flutter/material.dart';

class CreditCardPage extends StatelessWidget {
  static final String routeName = "credit-card";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "CREDIT CARD",
            style: AppTextStyles.appLightHeaderTextStyle,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container());
  }
}
