import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_fit_now/screens/mywallet.dart';
import 'package:go_fit_now/screens/searchlocation/searchlocation.dart';
import 'package:go_fit_now/new_search/new_searchlocation.dart';
import 'package:google_fonts/google_fonts.dart';


class appbarwidget extends StatefulWidget implements PreferredSizeWidget{
  const appbarwidget({key,this.appBartext}) : super(key: key);
  final String? appBartext;


  @override
  Size get preferredSize => const Size.fromHeight(50);
  _appbarwidgetState createState() => _appbarwidgetState();


}

class _appbarwidgetState extends State<appbarwidget> {

  List<String> cityname = ["patna","delhi","pammmm","dec","vv"];
  List<String> cityid=["1","2","3","4","5"];


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
//      backgroundColor: Colors.black,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      flexibleSpace: Image(
        image: AssetImage('assets/images/appbar.jpg'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
      title:widget.appBartext !=null ? Text("${widget.appBartext}",style: GoogleFonts.roboto(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),): Image.asset(
        'assets/images/logo.png',
        width: 80,
        height: 40,
      ),
      actions: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () async{

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => newcitysearch(isFromGYM: true,isFromSapa: false,isFromYoga: false),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(110)),
                       width: 35,
                     height: 35,
                alignment: Alignment.center,
                child: Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.black54,
                ),



              ),
            ),
            IconButton(
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => mywallet(),
                  ),
                );

              },
              icon: Icon(Icons.account_balance_wallet),
              color: Colors.white,
            ),
          ],
        )


      ],
    );

  }
}

