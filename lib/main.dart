import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/provider/googleMpaProvider.dart';
import 'package:dispatch_app_client/ui/pages/auth/loginPage.dart';
import 'package:dispatch_app_client/ui/pages/auth/signUpPage.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/confirmDispatch.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/dispatchListPage.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/recipientPage.dart';
import 'package:dispatch_app_client/ui/pages/home/homePage.dart';
import 'package:dispatch_app_client/ui/pages/settings/creditCardPage.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispatch_app_client/ui/pages/support/supportPage.dart';
import 'package:dispatch_app_client/ui/pages/settings/settingsPage.dart';
import 'package:dispatch_app_client/ui/pages/settings/addCreditCardPage.dart';
import 'ui/pages/dispatch/dispatchHistoryPage.dart';
import 'ui/pages/settings/myProfilePage.dart';
import 'ui/pages/settings/updatePasswordPage.dart';
import 'utils/customRoute.dart';

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
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
                TargetPlatform.android: CustomPageTransitionBuilder(),
              })),
          home: LoginPage(),
          routes: {
            SignUpPage.routeName: (context) => SignUpPage(),
            HompePage.routeName: (context) => HompePage(),
            RecipientPage.routeName: (context) => RecipientPage(),
            ConfirmDispatch.routeName: (context) => ConfirmDispatch(),
            DispatchListPage.routeName: (context) => DispatchListPage(),
            DispatchHistoryPage.routeName: (context) => DispatchHistoryPage(),
            DispatchListPage.routeName: (context) => DispatchListPage(),
            SupportPage.routeName: (context) => SupportPage(),
            SettingsPage.routeName: (context) => SettingsPage(),
            CreditCardPage.routeName: (context) => CreditCardPage(),
            AddCreditCardPage.routeName: (context) => AddCreditCardPage(),
            MyProfilePage.routeName: (context) => MyProfilePage(),
            UpdatePassowrd.routeName: (context) => UpdatePassowrd(),
          },
        ));
  }
}
