import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/more_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);


  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens ;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(context);
      print('llllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
      print(message.notification?.body);
      Provider.of<NotificationProvider>(context, listen: false).changeUnreadNoti(true);
    });
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel!.businessMode == "single";


    _screens = [
      const HomePage(),
      singleVendor?const OrderScreen(isBacButtonExist: false): const InboxScreen(isBackButtonExist: false) ,
      singleVendor? const NotificationScreen(isBacButtonExist: false): const OrderScreen(isBacButtonExist: false),
      singleVendor? const MoreScreen(): const NotificationScreen(isBacButtonExist: false),
      singleVendor?const SizedBox(): const MoreScreen(),
    ];

    NetworkInfo.checkConnectivity(context);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:  ColorResources.green,
          unselectedItemColor: Theme.of(context).textTheme.bodyLarge!.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Image.asset(icon, color: index == _pageIndex ?
          ColorResources.green: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
            height: 25, width: 25,
          ),
          if(label == getTranslated('notification', context))
            if(Provider.of<NotificationProvider>(context).unReadNoti)
            Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
              ),
            ),
          )
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> list = [];

    if(!isSingleVendor){
      list.add(_barItem(Images.homeOutline, getTranslated('home', context), 0));
      list.add(_barItem(Images.chats, getTranslated('inbox', context), 1));
      list.add(_barItem(Images.ordersImage, getTranslated('orders', context), 2));
      list.add(_barItem(Images.notification, getTranslated('notification', context), 3));
      list.add(_barItem(Images.moreImage, getTranslated('more', context), 4));
    }else{
      list.add(_barItem(Images.homeImage, getTranslated('home', context), 0));
      list.add(_barItem(Images.shoppingImage, getTranslated('orders', context), 1));
      list.add(_barItem(Images.notification, getTranslated('notification', context), 2));
      list.add(_barItem(Images.moreImage, getTranslated('more', context), 3));
    }

    return list;
  }

}