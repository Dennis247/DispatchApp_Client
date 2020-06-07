import 'package:dispatch_app_client/model/dispatch.dart';
import 'package:dispatch_app_client/model/response.dart';
import 'package:dispatch_app_client/provider/dispatchProvider.dart';
import 'package:dispatch_app_client/ui/widgets/dispatchHistoryWidget.dart';
import 'package:dispatch_app_client/utils/appStyles.dart';
import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DispatchHistoryPage extends StatefulWidget {
  static final String routeName = "dispatch-history";
  @override
  _DispatchHistoryPageState createState() => _DispatchHistoryPageState();
}

class _DispatchHistoryPageState extends State<DispatchHistoryPage> {
  bool _isLoading = false;
  List<Dispatch> _currentDispatchList = [];
  @override
  void initState() {
    getDispatchList();
    super.initState();
  }

  void _startLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void getDispatchList() async {
    _startLoading(true);
    final ResponseModel responseModel =
        await Provider.of<DispatchProvider>(context, listen: false)
            .getDispatchList();
    _startLoading(false);
    if (responseModel.isSUcessfull) {
      _currentDispatchList = dispatchList;
    } else {
      Constant.showFialureDialogue(responseModel.responseMessage, context);
    }
  }

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  String getDispatchStatus(int page) {
    final dispatchProvider =
        Provider.of<DispatchProvider>(context, listen: false);
    if (page == 0) {
      dispatchList = dispatchProvider.getDispatchLIst(
          Constant.dispatchActiveStatus, _currentDispatchList);
      return Constant.dispatchActiveStatus.toUpperCase();
    }
    if (page == 1) {
      dispatchList = dispatchProvider.getDispatchLIst(
          Constant.dispatchPendingStatus, _currentDispatchList);
      return Constant.dispatchPendingStatus.toUpperCase();
    }
    if (page == 2) {
      dispatchList = dispatchProvider.getDispatchLIst(
          Constant.dispatchCompletedStatus, _currentDispatchList);
      return Constant.dispatchCompletedStatus.toUpperCase();
    }
    if (page == 3) {
      dispatchList = dispatchProvider.getDispatchLIst(
          Constant.dispatchCancelledStatus, _currentDispatchList);
      return Constant.dispatchCancelledStatus.toUpperCase();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appSize = Constant.getAppSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getDispatchStatus(_page),
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
      body: _isLoading
          ? Center(child: Constant.circularInidcator())
          : Container(
              height: appSize.height,
              width: appSize.width,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: dispatchList.length,
                    itemBuilder: (context, index) => DispatchHistoryWidget(
                          dispatch: dispatchList[index],
                        )),
              ),
            ),
      bottomNavigationBar: _isLoading
          ? Text("")
          : CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              height: 50.0,
              items: <Widget>[
                Icon(
                  Icons.desktop_mac,
                  size: 25,
                  color: Constant.primaryColorLight,
                ),
                Icon(
                  Icons.list,
                  size: 25,
                  color: Constant.primaryColorLight,
                ),
                Icon(
                  Icons.account_balance,
                  size: 25,
                  color: Constant.primaryColorLight,
                ),
                Icon(
                  Icons.delete,
                  size: 25,
                  color: Constant.primaryColorLight,
                ),
              ],
              color: Constant.primaryColorDark,
              buttonBackgroundColor: Constant.primaryColorDark,
              backgroundColor: Constant.primaryColorLight,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) async {
                setState(() {
                  _page = index;
                });
              },
            ),
    );
  }
}
