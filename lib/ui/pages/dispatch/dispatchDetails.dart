import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/src/lib_export.dart';
import 'package:dispatch_app_client/ui/pages/dispatch/dispatchStausPage.dart';
import 'package:dispatch_app_client/ui/widgets/appButtonWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'dispatchLocation.dart';

class DispatchDetails extends StatefulWidget {
  final Dispatch dispatch;
  const DispatchDetails({Key key, this.dispatch}) : super(key: key);

  @override
  _DispatchDetailsState createState() => _DispatchDetailsState();
}

class _DispatchDetailsState extends State<DispatchDetails> {
  bool _isLoading = false;

  void _startLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  _buildRowDetails(String title, String subTitle) {
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

  _buildRowDetails2(String title, String subTitle, IconData iconData,
      String iconTitle, Function function) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
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
          ),
        ),
        _showCancelMapButton() == true
            ? SizedBox(
                width: 100,
                child: RaisedButton.icon(
                    color: Constant.primaryColorLight,
                    shape: StadiumBorder(),
                    onPressed: function,
                    icon: Icon(
                      iconData,
                      size: 16,
                      color: Constant.primaryColorDark,
                    ),
                    label: Text(
                      iconTitle,
                      style: AppTextStyles.smallDarkTextStyle,
                    )),
              )
            : Text("")
      ],
    );
  }

  _showCancelMapButton() {
    if (widget.dispatch.dispatchStatus == Constant.dispatchCompletedStatus ||
        widget.dispatch.dispatchStatus == Constant.dispatchCancelledStatus)
      return false;
    return true;
  }

  _showCurrentLocation() {
    if (widget.dispatch.dispatchStatus == Constant.dispatchCompletedStatus ||
        widget.dispatch.dispatchStatus == Constant.dispatchCancelledStatus ||
        widget.dispatch.dispatchStatus == Constant.dispatchPendingStatus)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appSzie = Constant.getAppSize(context);
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildRowDetails("Pick Up", widget.dispatch.pickUpLocation),
                Divider(),
                _buildRowDetails(
                    "Delivery Location", widget.dispatch.dispatchDestination),
                Divider(),
                _buildRowDetails(
                    "Dispatch Description",
                    widget.dispatch.dispatchDescription != null
                        ? widget.dispatch.dispatchDescription
                        : ""),
                Divider(),
                _buildRowDetails("Dispatch Type", widget.dispatch.dispatchType),
                Divider(),
                _buildRowDetails(
                    "Total Distance", widget.dispatch.estimatedDistance),
                Divider(),
                _isLoading
                    ? Constant.circularInidcator()
                    : _buildRowDetails2(
                        "Delivery Status",
                        widget.dispatch.dispatchStatus,
                        Icons.cancel,
                        "CANCEL", () async {
                        //   _startLoading(true);
                        //show warning dialogue
                        Constant.showConfirmationDialogue(
                            "Please Confirm Cancel DIspatch", context,
                            () async {
                          final response = await Provider.of<DispatchProvider>(
                                  context,
                                  listen: false)
                              .updateDispatchStatus(widget.dispatch.id,
                                  Constant.dispatchCancelledStatus);
                          if (response.isSUcessfull == true) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => DispatchStatus(
                                          dispatchMessage:
                                              Constant.cancellDispatchMessage,
                                          imageUrl: "assets/images/premiun.png",
                                          isDispatchProcessing: false,
                                        )),
                                (Route<dynamic> route) => false);
                          } else {
                            _startLoading(false);
                            Constant.showFialureDialogue(
                                response.responseMessage, context);
                          }
                        });
                      }),
                _showCurrentLocation() ? Divider() : SizedBox(),
                _showCurrentLocation()
                    ? _buildRowDetails2(
                        "current location",
                        widget.dispatch.currentLocation,
                        FontAwesomeIcons.mapPin,
                        "Map", () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DispatchLocation()));
                      })
                    : SizedBox(),
                Divider(),
                _buildRowDetails("Base Delivery Fee",
                    widget.dispatch.dispatchBaseFare.toString()),
                Divider(),
                _buildRowDetails("Total Delivery Fee",
                    widget.dispatch.dispatchTotalFare.toString()),
                Divider(),
                _buildRowDetails(
                    "Reciever Name", widget.dispatch.dispatchReciever),
                Divider(),
                _buildRowDetails("Reciever PhoneNumber",
                    widget.dispatch.dispatchRecieverPhone),
                SizedBox(
                  height: appSzie.height * 0.04,
                ),
                SizedBox(
                  height: appSzie.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.dispatch.dispatchStatus ==
              Constant.dispatchActiveStatus
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: AppRectButtonWidget(
                  width: appSzie.width,
                  buttonText: "COMPLTE DISPATCH",
                  function: () {
                    Constant.showConfirmationDialogue(
                        "Confirm that your dispatch is complete", context,
                        () async {
                      Provider.of<DispatchProvider>(context, listen: false)
                          .updateDispatchStatus(widget.dispatch.id,
                              Constant.dispatchCompletedStatus);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => DispatchStatus(
                                dispatchMessage:
                                    "Dispatch Complted Sucessfully",
                                isDispatchProcessing: false,
                                imageUrl: "assets/images/express.png",
                              )));
                    });
                  },
                ),
              ),
            )
          : Text(""),
    );
  }
}
