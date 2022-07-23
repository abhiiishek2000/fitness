// @dart=2.9
import 'package:flutter/material.dart';
import 'package:go_fit_now/home/home_screen_1.dart';
import 'package:go_fit_now/screens/HomePage.dart';
import 'package:go_fit_now/screens/LoginScreen.dart';
import 'package:go_fit_now/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/constant.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
SharedPreferences prefs = await SharedPreferences.getInstance();
var userid = prefs.getString('userid');   //  getting session id from shared pref

if (userid == null) {              // for new user or generating sesstion id
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();


  prefs.setString('userid', 'null');
  prefs.setString('username', 'null');
}
  runApp(MaterialApp(
  title: 'Go Fit Now' ,
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
      primarySwatch: Colors.blue
  ),
  routes: <String, WidgetBuilder> {
    Constants.SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
    Constants.LOGIN_PAGE: (BuildContext context) => LoginPage(),
    // Constants.HOME_SCREEN: (BuildContext context) => HomePage(cityname: "Patna",cityid: "1",),
    Constants.HOME_SCREEN: (BuildContext context) => HomeScreen(cityname: "Patna",cityid: "1",),
  },
  initialRoute: Constants.SPLASH_SCREEN,
));
}


