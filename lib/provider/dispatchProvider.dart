import 'dart:convert';

import 'package:dispatch_app_client/model/PlaceDistanceTime.dart';
import 'package:dispatch_app_client/model/dispatch.dart';
import 'package:dispatch_app_client/model/notification.dart';
import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/provider/authProvider.dart';
import 'package:dispatch_app_client/provider/notificatiomProvider.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

Dispatch currentDispatch;
List<Dispatch> dispatchList;
String recieverPhone;
String recieverName;
String dispatchDescription;
final dispatchRef = FirebaseDatabase.instance.reference().child('dispatch');

class DispatchProvider with ChangeNotifier {
  Uuid uuid = Uuid();
  Future<ResponseModel> getDispatchList() async {
    dispatchList = dispatchList == null ? [] : dispatchList;
    List<Dispatch> alldispatch = [];
    try {
      dispatchList.clear();
      await dispatchRef
          .orderByChild("dispatchDate")
          //  .equalTo(loggedInUser.id)
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> dbDispatchLIst = dataSnapshot.value;
        dbDispatchLIst.forEach((key, value) {
          final dispatch = Dispatch(
              id: value['id'],
              userId: value['userId'],
              trackingNo: value['trackingNo'],
              dispatchRiderId: value['dispatchRiderId'],
              dispatchDate: DateTime.parse(value['dispatchDate']),
              pickUpLocation: value['pickUpLocation'],
              dispatchDestination: value['dispatchDestination'],
              dispatchBaseFare:
                  double.parse(value['dispatchBaseFare'].toString()),
              dispatchTotalFare:
                  double.parse(value['dispatchTotalFare'].toString()),
              dispatchType: value['dispatchType'],
              dispatchStatus: value['dispatchStatus'],
              currentLocation: value['currentLocation'],
              estimatedDIspatchDuration: value['estimatedDIspatchDuration'],
              estimatedDistance: value['estimatedDistance'],
              dispatchReciever: value['dispatchReciever'],
              dispatchRecieverPhone: value['dispatchRecieverPhone'],
              dispatchDescription: value['dispatchDescription']);
          alldispatch.add(dispatch);
        });
      });
      dispatchList =
          alldispatch.where((d) => d.userId == loggedInUser.id).toList();

      dispatchList.sort((b, a) => a.dispatchDate.compareTo(b.dispatchDate));
      return ResponseModel(true, "Disatch list gotten sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  List<Dispatch> getDispatchLIst(String dispatchStatus, List<Dispatch> list) {
    List<Dispatch> dispatchReturn = [];
    if (dispatchStatus == Constant.dispatchPendingStatus) {
      dispatchReturn = list
          .where((ds) => ds.dispatchStatus == Constant.dispatchPendingStatus)
          .toList();
    }
    if (dispatchStatus == Constant.dispatchActiveStatus) {
      dispatchReturn = list
          .where((ds) => ds.dispatchStatus == Constant.dispatchActiveStatus)
          .toList();
    }
    if (dispatchStatus == Constant.dispatchCompletedStatus) {
      dispatchReturn = list
          .where((ds) => ds.dispatchStatus == Constant.dispatchCompletedStatus)
          .toList();
    }
    if (dispatchStatus == Constant.dispatchCancelledStatus) {
      dispatchReturn = list
          .where((ds) => ds.dispatchStatus == Constant.dispatchCancelledStatus)
          .toList();
    }
    dispatchReturn.sort((b, a) => a.dispatchDate.compareTo(b.dispatchDate));
    return dispatchReturn;
  }

  Future<ResponseModel> addDispatch(Dispatch dispatch) async {
    dispatchList = dispatchList == null ? [] : dispatchList;
    try {
      await dispatchRef.child(dispatch.id).set({
        "id": dispatch.id,
        "userId": dispatch.userId,
        "trackingNo": dispatch.trackingNo,
        "dispatchRiderId": dispatch.dispatchRiderId,
        "dispatchDate": DateTime.now().toIso8601String(),
        "pickUpLocation": dispatch.pickUpLocation,
        "dispatchDestination": dispatch.dispatchDestination,
        "dispatchBaseFare": dispatch.dispatchBaseFare,
        "dispatchType": dispatch.dispatchType,
        "dispatchStatus": dispatch.dispatchStatus,
        "currentLocation": dispatch.currentLocation,
        "estimatedDIspatchDuration": dispatch.estimatedDIspatchDuration,
        "estimatedDistance": dispatch.estimatedDistance,
        "dispatchTotalFare": dispatch.dispatchTotalFare,
        "dispatchReciever": dispatch.dispatchReciever,
        "dispatchRecieverPhone": dispatch.dispatchRecieverPhone,
        "dispatchDescription": dispatch.dispatchDescription
      });
      dispatchList.add(dispatch);
      await createPendingDispatchNotification(dispatch);
      return ResponseModel(true, "Dispatch Created Sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<ResponseModel> createDispatch(String dispatchType,
      String pickUpLocation, String dispatchDestination, String token) async {
    try {
      final placeDistanceTime = await getPlaceDistanceTimeWithAddress(
          pickUpLocation, dispatchDestination, token);
      final Dispatch dispatch = new Dispatch(
          id: uuid.v4(),
          userId: loggedInUser.id,
          trackingNo: "DISP001",
          dispatchRiderId: uuid.v4(),
          dispatchDate: DateTime.now(),
          pickUpLocation: pickUpLocation,
          dispatchDestination: dispatchDestination,
          dispatchBaseFare: Constant.dispatchBaseFare,
          dispatchType: dispatchType,
          dispatchStatus: Constant.dispatchPendingStatus,
          currentLocation: "",
          estimatedDIspatchDuration: placeDistanceTime.duration,
          estimatedDistance: placeDistanceTime.distance,
          dispatchTotalFare: 5000,
          dispatchReciever: recieverName,
          dispatchRecieverPhone: recieverPhone,
          dispatchDescription: dispatchDescription);
      currentDispatch = dispatch;
      return ResponseModel(true, "dispatch created sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<PlaceDistanceTime> getPlaceDistanceTimeWithAddress(
      String origin, String destination, String sessionToken) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json';
    String url =
        '$baseUrl?origins=$origin&destinations=$destination&key=${Constant.apiKey}&travelMode=driving&sessiontoken=$sessionToken';
    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final PlaceDistanceTime placeDistanceTime =
        PlaceDistanceTime.fromJson(responseData);
    return placeDistanceTime;
  }

  Future<PlaceDistanceTime> getPlaceDistanceTimeWIthCordinate(
      LatLng origin, LatLng destination, String sessionToken) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json';
    String url =
        '$baseUrl?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=${Constant.apiKey}&travelMode=driving&sessiontoken=$sessionToken';
    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final PlaceDistanceTime placeDistanceTime =
        PlaceDistanceTime.fromJson(responseData);
    return placeDistanceTime;
  }

  Future<ResponseModel> updateDispatchStatus(
      String dispatchId, String status) async {
    try {
      dispatchRef.child(dispatchId).update({'dispatchStatus': status});
      return ResponseModel(true, "Dispatch Staus Updated Sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  Future<void> createPendingDispatchNotification(Dispatch dispatch) async {
    try {
      final DispatchNotification dispatchNotification =
          new DispatchNotification(
              id: uuid.v4(),
              message:
                  Constant.pendingDispatchMessage + dispatch.pickUpLocation,
              dispatchId: dispatch.id,
              userId: dispatch.userId,
              notificationType: Constant.pendingDispatchNotification,
              pickUp: dispatch.pickUpLocation,
              notificationDate: DateTime.now(),
              recipientPhone: dispatch.dispatchRecieverPhone,
              isUserNotification: false,
              isNotificationSent: false);

      await notificationRef.child(dispatchNotification.id).set({
        "id": dispatchNotification.id,
        "message": dispatchNotification.message,
        "dispatchId": dispatchNotification.dispatchId,
        "userId": dispatchNotification.userId,
        "notificationType": dispatchNotification.notificationType,
        "pickUp": dispatchNotification.pickUp,
        "recipientPhone": dispatchNotification.recipientPhone,
        "isNotificationSent": dispatchNotification.isNotificationSent,
        "isUserNotification": dispatchNotification.isUserNotification,
        "notificationDate": dispatchNotification.notificationDate.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
