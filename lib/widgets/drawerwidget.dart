import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_fit_now/screens/LoginScreen.dart';
import 'package:go_fit_now/screens/entryform.dart';
import 'package:go_fit_now/screens/multipledatetest.dart';
import 'package:go_fit_now/screens/myorders.dart';
import 'package:go_fit_now/screens/mywallet.dart';
import 'package:go_fit_now/screens/order_pass.dart';
import 'package:go_fit_now/screens/payment.dart';
import 'package:go_fit_now/screens/profile.dart';
import 'package:go_fit_now/new_search/new_searchlocation.dart';
import 'package:go_fit_now/screens/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';


class drawerwidget extends StatefulWidget {
  @override
  _drawerwidgetState createState() => _drawerwidgetState();
}

class _drawerwidgetState extends State<drawerwidget> {

  String userid="";
  String username="";


  void initState() {
    super.initState();
    fetchdatauser();
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: new Text(username),
              accountEmail: new Text(userid),
              currentAccountPicture: new GestureDetector(
                onTap: () {},
                child: new CircleAvatar(
                  backgroundImage: new AssetImage('assets/images/userlogo.jpg'),
                    ),
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  onTap: () => print("this is the other user"),
                  child: new CircleAvatar(
          backgroundImage: new AssetImage('assets/images/logo.png'),


                      ),
                ),
              ],
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/appbar.jpg'),
                  ))),
          new ListTile(
              title: new Text("Home"),
              leading: new Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
              }),
          new ListTile(
              title: new Text("Profile"),
              leading: new Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(),
                  ),
                );
              }),
          new ListTile(
              title: new Text("Wallet"),
              leading: new Icon(Icons.account_balance_wallet),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => mywallet(),
                  ),
                );
              }),
          new ListTile(
              title: new Text("Help"),
              leading: new Icon(Icons.help),
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => testdatepicker(),
                //   ),
                // );
              }),
          new ListTile(
              title: new Text("My Booking"),
              leading: new Icon(Icons.bookmark_border),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Myorders(),
                  ),
                );
              }),
          new Divider(),
          new ListTile(
            title: new Text("Terms & Condition"),
            leading: new Icon(Icons.list_alt),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Webview(url: 'https://biographydad.com/privacy_policy.html',),
                ),
              );
            }
          ),
          new ListTile(
            title: new Text("Refund Policy"),
            leading: new Icon(Icons.attach_money),
            onTap: () {

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => OrderPass(),
              //   ),
              // );

            },
          ),
          new Divider(),
          new ListTile(
            title: new Text("Logout"),
            leading: new Icon(Icons.logout),

            onTap: () => showAlertDialog(context),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(10),
              height: 150,
              child: Text("V.0.0.7",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
      ),
    );
  }











  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget yesButton = TextButton(
      child: Text("Yes",style: TextStyle(color: Colors.lightGreen,fontSize: 20),),
      onPressed:  () async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();

        prefs.setString('userid', "null");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
        );
      },
    );
    Widget noButton = TextButton(
      child: Text("No",style: TextStyle(color: Colors.red,fontSize: 20),),
      onPressed:  () {Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(

        child: Row(
            children:[
              IconButton(icon: Icon(Icons.notifications_none,size: 25,color: Colors.red),onPressed: () {},),
              Text('GO FIT NOW',style: TextStyle(color:Colors.red),)
            ]
        ),
      ),
      //title: Text("PM Mart",style: TextStyle(color: Colors.red),),
      content: Text("Are You Sure Want to Logout?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> fetchdatauser() async {

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userid')!;
      username = prefs.getString('username')!;
    });



    return "Success";
  }
}
