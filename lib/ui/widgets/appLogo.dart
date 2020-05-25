import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appSzie = Constant.getAppSize(context);
    final circularRadius = appSzie.width * 0.5;
    return Container(
      width: appSzie.width,
      height: appSzie.height * 0.4,
      alignment: Alignment.center,
      child: Icon(
        FontAwesomeIcons.truck,
        size: 100,
        color: Colors.greenAccent,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(circularRadius),
          bottomLeft: Radius.circular(circularRadius),
        ),
        color: Constant.primaryColorDark,
      ),
    );
  }
}
