import 'dart:async';

import 'package:dispatch_app_client/ui/widgets/appDrawer.dart';
import 'package:dispatch_app_client/ui/widgets/appInputWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HompePage extends StatefulWidget {
  static final routeName = "home-page";
  @override
  _HompePageState createState() => _HompePageState();
}

class _HompePageState extends State<HompePage> {
  LatLng myLocation = LatLng(6.5244, 3.3792);
  Completer<GoogleMapController> _controller = Completer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _mapStyle;
  @override
  void initState() {
    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appSize = Constant.getAppSize(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: Stack(
          children: <Widget>[
            Container(
              height: appSize.height,
              width: appSize.width,
            ),
            Container(
              width: appSize.width,
              height: appSize.height * 0.7,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: myLocation, zoom: 15),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                  _controller.complete(controller);
                },
              ),
            ),
            Positioned(
              top: 15.0,
              left: 10.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Constant.primaryColorDark,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
              ),
            ),
            Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.transparent,
                      width: appSize.width,
                      child: Column(
                        children: <Widget>[
                          AppTextSmallInputWIdget(
                            labelText: "From",
                            obscureText: false,
                            prefixIcon: FontAwesomeIcons.truck,
                            prefixColor: Colors.green,
                            labelTextSTyle: AppTextStyles.greenlabelTextStyle,
                          ),
                          AppTextSmallInputWIdget(
                            labelText: "To",
                            obscureText: false,
                            prefixIcon: Icons.pin_drop,
                            prefixColor: Colors.red,
                            labelTextSTyle: AppTextStyles.redlabelTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
