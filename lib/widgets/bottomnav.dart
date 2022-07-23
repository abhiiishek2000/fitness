import 'dart:convert';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/home/home_screen_1.dart';
import 'package:go_fit_now/screens/HomePage.dart';
import 'package:go_fit_now/screens/mywallet.dart';
import 'package:go_fit_now/screens/profile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class bottomnavwidget extends StatefulWidget implements PreferredSizeWidget{

  final int selectedIndex;
  bottomnavwidget({Key? key, required this.selectedIndex}) : super(key: key);


  @override
  Size get preferredSize => const Size.fromHeight(50);
  _bottomnavwidgetState createState() => _bottomnavwidgetState();


}

class _bottomnavwidgetState extends State<bottomnavwidget> {




  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var _selectedIndex;
    return FancyBottomNavigation(
      tabs: [

        // TabData(iconData: Icons.search, title: "Search"),
        TabData(iconData: Icons.account_balance_wallet_rounded, title: "Wallet"),
        TabData(iconData: Icons.home, title: "Home"),
        // TabData(iconData: Icons.bookmark_border, title: "Order"),
        TabData(iconData: Icons.account_circle, title: "Profile")
      ],
      // initialSelection: 1,
      initialSelection:widget.selectedIndex,
      circleColor: Colors.orange,
      inactiveIconColor: Colors.orange,

      onTabChangedListener: (position) {
        if(position==1){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(cityid: '1',cityname: "patna",)),
                (Route<dynamic> route) => false,
          );

        }
        else if(position==2){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserProfile()),
                (Route<dynamic> route) => false,
          );

        }
        else if(position==0){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => mywallet()),
                (Route<dynamic> route) => false,
          );


        }
        // setState(() {
        //   _selectedIndex = position;
        // });
      },
    );

  }


}
