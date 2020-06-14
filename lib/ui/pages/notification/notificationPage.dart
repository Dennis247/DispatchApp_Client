import 'package:dispatch_app_client/provider/notificatiomProvider.dart';
import 'package:dispatch_app_client/ui/widgets/notificationWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  static final String routeName = "notification-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NOTIFICATIONS",
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
      body: StreamBuilder(
          stream: notificationRef.orderByChild('notificationDate').onValue,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Constant.circularInidcator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "An Error Occured loading Notifications",
                    style: AppTextStyles.appTextStyle,
                  ),
                );
              } else {
                DataSnapshot dataSnapshot = snapshot.data.snapshot;
                final dispatchNotifications =
                    Provider.of<NotificationProvider>(context, listen: false)
                        .getStreamDIspatchList(dataSnapshot);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dispatchNotifications.length > 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: dispatchNotifications.length,
                          itemBuilder: (context, index) => NotificationWidget(
                                dispatchNotification:
                                    dispatchNotifications[index],
                              ))
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.bellSlash,
                                size: 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Notification list is empty",
                                style: AppTextStyles.appTextStyle,
                              )
                            ],
                          ),
                        ),
                );
              }
            }
          }),
    );
  }
}
