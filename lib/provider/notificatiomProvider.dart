import 'package:dispatch_app_client/model/notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dispatch_app_client/provider/authProvider.dart';

final notificationRef =
    FirebaseDatabase.instance.reference().child('notification');
FlutterLocalNotificationsPlugin flp;

class NotificationProvider with ChangeNotifier {
  void initialisePushNotification() {
    flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);
    flp.initialize(initSetttings);
  }

  // void showNotification(String notificationMessage,FlutterLocalNotificationsPlugin  flp) async {
  //   var android = AndroidNotificationDetails(
  //       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
  //       priority: Priority.High, importance: Importance.Max);
  //   var iOS = IOSNotificationDetails();
  //   var platform = NotificationDetails(android, iOS);
  //   await flp.show(0, notificationMessage, platform,
  //       payload: notificationMessage);
  // }

  void displayNotification(String title, String notificationMessage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'dispatch notifications',
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flp.show(0, title, notificationMessage, platformChannelSpecifics,
        payload: notificationMessage);
  }

  List<DispatchNotification> getStreamDIspatchList(DataSnapshot dataSnapshot) {
    List<DispatchNotification> allNotification = [];
    Map<dynamic, dynamic> dbNotificationLIst = dataSnapshot.value;
    if (dataSnapshot.value != null) {
      dbNotificationLIst.forEach((key, value) {
        final notification = DispatchNotification(
            id: value['id'],
            message: value['message'],
            dispatchId: value['dispatchId'],
            userId: value['userId'],
            notificationType: value['notificationType'],
            pickUp: value['pickUp'],
            recipientPhone: value['recipientPhone'],
            isUserNotification: value['isUserNotification'],
            notificationDate: DateTime.parse(value['notificationDate']),
            isNotificationSent: value['isNotificationSent']);
        allNotification.add(notification);
      });
      allNotification =
          allNotification.where((e) => e.userId == loggedInUser.id).toList();
      allNotification
          .sort((b, a) => a.notificationDate.compareTo(b.notificationDate));
      return allNotification;
    }
    return List<DispatchNotification>();
  }
}
