import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/provider/googleMpaProvider.dart';
import 'package:dispatch_app_client/ui/pages/auth/loginPage.dart';
import 'package:dispatch_app_client/ui/pages/auth/signUpPage.dart';
import 'package:dispatch_app_client/ui/pages/home/homePage.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: GoogleMapProvider()),
          ChangeNotifierProvider.value(value: DispatchProvider()),
        ],
        child: MaterialApp(
          title: 'Dispatch App',
          theme: ThemeData(
            primaryColor: Constant.primaryColorDark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(),
          routes: {
            SignUpPage.routeName: (context) => SignUpPage(),
            HompePage.routeName: (context) => HompePage()
          },
        ));
  }
}
