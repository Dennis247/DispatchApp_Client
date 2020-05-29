import 'package:dispatch_app_client/ui/pages/dispatch/dispatchHistoryPage.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/dispatchListPage.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              FontAwesomeIcons.user,
              color: Constant.primaryColorDark,
              size: 40,
            ),
            title: Text(
              "Good Morning",
              style: AppTextStyles.smallprimaryColorTextStyle,
            ),
            subtitle: Text(
              "Osagiede Dennis",
              style: AppTextStyles.appTextStyle,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(DispatchHistoryPage.routeName);
                  },
                  child: Text(
                    "Dispatch History",
                    style: AppTextStyles.appTextStyle,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Share.share(
                      "https://github.com/Dennis247/green_taxi",
                      subject: "Invite Your Friend To Green Taxi",
                    );
                  },
                  child: Text(
                    "Invite Friends",
                    style: AppTextStyles.appTextStyle,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(DispatchListPage.routeName);
                  },
                  child: Text(
                    "Settings",
                    style: AppTextStyles.appTextStyle,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Support",
                    style: AppTextStyles.appTextStyle,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Text("Log Out", style: AppTextStyles.appTextStyle),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
