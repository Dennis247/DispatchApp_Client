import 'package:dispatch_app_client/ui/pages/dispatch/dispatchHistoryPage.dart';
import 'package:dispatch_app_client/ui/pages/home/homePage.dart';
import 'package:dispatch_app_client/ui/widgets/appButtonWidget.dart';
import 'package:dispatch_app_client/ui/widgets/appTextWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';

class DispatchStatus extends StatelessWidget {
  final String imageUrl;
  final String dispatchMessage;
  final bool isDispatchProcessing;

  const DispatchStatus(
      {Key key, this.imageUrl, this.dispatchMessage, this.isDispatchProcessing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appSzie = Constant.getAppSize(context);
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: Container(
            width: appSzie.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      imageUrl,
                      scale: 1.5,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.05,
                    ),
                    Text.rich(
                      AppTextWidget.appTextSpan("request ", "Sucessfull"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.02,
                    ),
                    Text(
                      dispatchMessage,
                      style: AppTextStyles.appTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: appSzie.height * 0.05,
                    ),
                    AppSmallButtonWudget(
                      buttonText: "OK",
                      function: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HompePage.routeName,
                            (Route<dynamic> route) => false);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
