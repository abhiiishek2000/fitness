import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/screens/mywallet.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_fit_now/widgets/bottomnav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List data=[];
  late String username;
  late String alt_mob;
  late String email;
  late String userid;
  late String wallet_amount;
  late String refral_code;
  bool _progressBarActive=true;




  @override
  void initState() {
    super.initState();
    fetchdatauser();

  }

  Future<String> fetchdatauser() async {

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid')!;

    print(userid);

    var jsonData = await http.get("https://biographydad.com/api/useridcheck/$userid");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];

      _progressBarActive=false;
    });
    print("vvvvvvvvvvv${data.length}");
    if (data.length != 0) {
      setState(() {
        data.forEach((element) {

          username = element['name'];
          email = element['email'];
          alt_mob = element['alt_mob'];
          wallet_amount = element['wallet_amount'];
          refral_code =element['refral_code'];


      });

      });


    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: _progressBarActive == true
            ? Container(
            height: size.height / 1.5,
            child: Center(
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )))
            :ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/appbar.jpg'),
                              fit: BoxFit.cover
                          ) ,
                        ),
                        // decoration: BoxDecoration(
                        //
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     stops: [0.1, 0.5],
                        //     colors: [
                        //       Colors.indigo,
                        //       Colors.indigoAccent,
                        //     ],
                        //   ),
                        // ),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Container(
                          padding: EdgeInsets.only(top: 10, right: 7),
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              FlutterIcons.gear_faw,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => UserSettings(),
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 5,
                        padding: EdgeInsets.only(top: 75),
                        child: Text(
                          username,
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/userlogo.jpg'),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          // color: Colors.teal[50],
                          width: 5,
                        ),
                        shape: BoxShape.circle),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.only(left: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.red[900],
                            child: Icon(
                              Icons.mail_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          email,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.blue[800],
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            userid,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(30),
                    //       child: Container(
                    //         height: 27,
                    //         width: 27,
                    //         color: Colors.blue[800],
                    //         child: Icon(
                    //           Icons.phone,
                    //           color: Colors.white,
                    //           size: 16,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //         alt_mob
                    //     ),
                    //   ],
                    // ),



                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.only(left: 20),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Share And Earn",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Spacer(),
                        Container(
                          // width: double.maxFinite,
                          child: RaisedButton.icon(
                            color: Colors.blue,
                            onPressed: () {

                              Clipboard.setData(ClipboardData(text: refral_code));
                              Fluttertoast.showToast(msg: "Copied to Clipboard");
                            },
                            label: Text('Copy code', style: TextStyle(color: Colors.white)),
                            icon: Icon(Icons.copy, color: Colors.white),
                            textColor: Colors.white,
                            splashColor: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.red[900],
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          refral_code,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),






                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                // decoration: BoxDecoration(
                //     color: Color.fromARGB(255, 20, 0, 100),
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(40),
                //       bottomRight: Radius.circular(40),
                //     )),
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //       image: AssetImage('assets/images/appbar.jpg'),
                //       fit: BoxFit.cover
                //   ) ,
                // ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => mywallet(),
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  color: Colors.green[800],
                                  child: Icon(
                                    Icons.attach_money_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),

                              Text(
                                "Wallet Current Balance",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Rs.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Text(
                                "Rs. $wallet_amount ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold
                                ),
                              ),

                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Color(0xFF2ecc71),
                              //     borderRadius: BorderRadius.circular(16),
                              //   ),
                              //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              //   child: Text(
                              //     "+ 3.5 %",
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold
                              //     ),
                              //   ),
                              // ),

                            ],
                          ),
                        ),

                        SizedBox(height: 80,),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Secured",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Text("Tap To View Transaction  >>>",style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),)
                            ],
                          ),
                        ),

                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey[50],
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color(0xFFe67e22),
                      //     Color(0xFFf1c40f),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
            ],
          ),

      ),
      bottomNavigationBar: bottomnavwidget(selectedIndex: 2),
    );
  }

  // Widget getBio() {
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData)
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       var userData = snapshot.data;
  //       return Container(
  //         alignment: Alignment.centerLeft,
  //         padding: EdgeInsets.only(top: 10, left: 40),
  //         child: Text(
  //           userData['bio'] == null ? "No Bio" : userData['bio'],
  //           style: GoogleFonts.lato(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.black38,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
