//import 'package:http/http.dart' as http;
import 'package:dispatch_app_client/src/lib_export.dart';

final notificationRef =
    FirebaseDatabase.instance.reference().child('notification');

class NotificationProvider with ChangeNotifier {
  void displayNotification(String title, String notificationMessage) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);
    flp.initialize(initSetttings);
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
            isNotificationSent: value['isNotificationSent'],
            tokens: value['tokens']);
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
