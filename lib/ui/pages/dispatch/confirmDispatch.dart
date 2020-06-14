import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/provider/notificatiomProvider.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/dispatchStausPage.dart';
import 'package:dispatch_app_client/ui/widgets/appButtonWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDispatch extends StatefulWidget {
  static final String routeName = "confirm-dispatch";

  @override
  _ConfirmDispatchState createState() => _ConfirmDispatchState();
}

class _ConfirmDispatchState extends State<ConfirmDispatch> {
  bool _isloading = false;
  _buildConfrimRowItem(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyles.smallgreyTextStyle,
        ),
        Text(
          subTitle,
          style: AppTextStyles.appTextStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appSzie = Constant.getAppSize(context);
    final dispatchProvider =
        Provider.of<DispatchProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DISPATCH DETAILS",
          style: AppTextStyles.appLightHeaderTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        height: appSzie.height,
        width: appSzie.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildConfrimRowItem(
                      "Pick Up", currentDispatch.pickUpLocation),
                  Divider(),
                  _buildConfrimRowItem(
                      "Delivery Location", currentDispatch.dispatchDestination),
                  Divider(),
                  _buildConfrimRowItem(
                      "Dispatch Type", currentDispatch.dispatchType),
                  Divider(),
                  _buildConfrimRowItem(
                      "Total Distance", currentDispatch.estimatedDistance),
                  Divider(),
                  _buildConfrimRowItem("Estimated Time",
                      currentDispatch.estimatedDIspatchDuration),
                  Divider(),
                  _buildConfrimRowItem("Base Delivery Fee", "N 1000"),
                  Divider(),
                  _buildConfrimRowItem("Total Delivery Fee", "N 5000"),
                  Divider(),
                  _buildConfrimRowItem(
                      "Reciever Name", currentDispatch.dispatchReciever),
                  Divider(),
                  _buildConfrimRowItem("Reciever PhoneNumber",
                      currentDispatch.dispatchRecieverPhone),
                  SizedBox(
                    height: appSzie.height * 0.05,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: _isloading
                        ? Constant.circularInidcator()
                        : AppButtonWudget(
                            buttonText: "CONFIRM DISPATCH",
                            function: () async {
                              setState(() {
                                _isloading = true;
                              });
                              final ResponseModel responseModel =
                                  await dispatchProvider
                                      .addDispatch(currentDispatch);
                              if (responseModel.isSUcessfull) {
                                //show custom sucess dialogue before navigating
                                notificationProvider.displayNotification(
                                    "Dispatch Sucessfull",
                                    "Dispatch Rider on the way for pick up!");
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => DispatchStatus(
                                              imageUrl:
                                                  "assets/images/express.png",
                                              dispatchMessage: Constant
                                                  .processDispatchMessage,
                                              isDispatchProcessing: true,
                                            )));

                                //show dispatch notification
                              } else {
                                setState(() {
                                  _isloading = false;
                                });
                                Constant.showFialureDialogue(
                                    responseModel.responseMessage, context);
                              }
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
