import 'dart:convert';

import 'package:dispatch_app_client/model/PlaceDistanceTime.dart';
import 'package:dispatch_app_client/model/dispatch.dart';
import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/provider/authProvider.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

Dispatch currentDispatch;
List<Dispatch> dispatchList;
String recieverPhone;
String recieverAddress;

class DispatchProvider with ChangeNotifier {
  Uuid uuid = Uuid();
  final dispatchRef = FirebaseDatabase.instance.reference().child('dispatch');
  Future<ResponseModel> addDispatch(Dispatch dispatch) async {
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
        "dispatchRecieverPhone": dispatch.dispatchRecieverPhone
      });
      dispatchList.add(dispatch);
      return ResponseModel(true, "Dispatch Created Sucessfully");
    } catch (e) {
      return ResponseModel(true, e.toString());
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
          dispatchReciever: recieverAddress,
          dispatchRecieverPhone: recieverPhone);
      currentDispatch = dispatch;
      return ResponseModel(true, "dispatch created sucessfully");
    } catch (e) {
      return ResponseModel(true, e.toString());
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
}
