import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DispatchHistoryPage extends StatefulWidget {
  static final String routeName = "dispatch-history";
  @override
  _DispatchHistoryPageState createState() => _DispatchHistoryPageState();
}

class _DispatchHistoryPageState extends State<DispatchHistoryPage> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  String getDispatchStatusTitle(int page) {
    if (page == 0) return "ACTIVE";
    if (page == 1) return "PENDING";
    if (page == 2) return "COMPLETED";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appSize = Constant.getAppSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getDispatchStatusTitle(_page),
          style: AppTextStyles.appDarkHeaderTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Constant.primaryColorLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Constant.primaryColorDark,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        height: appSize.height,
        width: appSize.width,
        child: Center(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.desktop_mac,
            size: 30,
            color: Constant.primaryColorLight,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Constant.primaryColorLight,
          ),
          Icon(
            Icons.account_balance,
            size: 30,
            color: Constant.primaryColorLight,
          ),
        ],
        color: Constant.primaryColorDark,
        buttonBackgroundColor: Constant.primaryColorDark,
        backgroundColor: Constant.primaryColorLight,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
