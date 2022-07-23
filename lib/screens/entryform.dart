import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_fit_now/screens/HomePage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryForm extends StatefulWidget {
  final String mobnum;
  const EntryForm( {Key? key, required this.mobnum}) : super(key: key);

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;
  final name = TextEditingController();
  final altnum = TextEditingController();
  final email = TextEditingController();
  final enteredreferral = TextEditingController();
  final building = TextEditingController();
  final landmark = TextEditingController();
  final district = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String Referreduser;
  List data=[];
  bool referal=false;

  bool _progressBarActive=false;
  @override
  Widget build(BuildContext context) {
    var _chosenValue;
    return Scaffold(
      body:Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        // fit: BoxFit.fill
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    "Fill the Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                // Container(
                //   child: Center(
                //     child: DropdownButton<String>(
                //       value: _chosenValue,
                //       underline: Container(), // this is the magic
                //       items: <String>['Google', 'Apple', 'Amazon', 'Tesla']
                //           .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //       onChanged: (String ?value) {
                //         setState(() {
                //         _chosenValue = value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                Center(
                    child: new Text(
                  "Fill the Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 15,),


                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                        controller: name,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.supervised_user_circle_rounded,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "Enter Name*",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {

                          if (value == null || value.isEmpty ) {
                            return 'Please enter Alternate Mobile Number';
                          }
                          else if (value.length!=10 ) {
                            return 'Please Enter Valid Number';
                          }
                          return null;
                        },
                        controller: altnum,
                        maxLength: 10,

                        keyboardType: TextInputType.number,

                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "Alternate Mobile Number",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          else if (!value.contains('@') || !value.endsWith('.com') ) {
                            return 'Please Enter Valid Email';
                          }

                          return null;
                        },
                        controller: email,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "Email*",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),



                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter District';
                          }
                          return null;
                        },
                        controller: district,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "District*",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter District';
                          // }
                          // return null;
                        },
                        controller: enteredreferral,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.code,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                          ),
                          hintText: "Enter Referral if Available",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                BouncingWidget(
                  onPressed: () {

                    if (_formKey.currentState!.validate()){
                      setState(() {
                        _progressBarActive=true;
                      });
                      print(enteredreferral.text!=null);

                      if(enteredreferral.text.isNotEmpty){
                        Checkreferral();
                        print("referral");
                      }
                      else{
                        makePostRequest();
                        print("no referral");
                      }


                    }


                  },

                  child: Container(
                    height: 60,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.white,
                    ),
                    child: _progressBarActive
                        ? Container(
                        child: Center(
                            child: const CircularProgressIndicator(backgroundColor: Colors.red,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),))):Center(
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8185E2),
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        )),
      )
    );
  }

  makePostRequest() async {

    DateTime _now = DateTime.now();
    String userreferral = 'gofit${_now.hour}${_now.minute}${_now.second}${_now.millisecond}';


    final uri = Uri.parse('https://biographydad.com/api/useradd');

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'name': name.text,
      'user_id': widget.mobnum,
      'address':district.text,
      'email':email.text,
      'refral_code': userreferral,
      'alt_mob':altnum.text,
      'landmark':null,
      'city':district.text,
      'state':state.text,
      'pincode':"800020",
      'user_img':null,
      'created_by': null,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    Map<String, dynamic> data = jsonDecode(response.body);
    print(responseBody);
    print(data['Message']);

    if(referal==true){
      addmoney(Referreduser,100);
      addmoney(widget.mobnum,100);
    }


    setState(() {
      _progressBarActive=false;
    });

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    prefs.setString('userid', widget.mobnum);



    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage(cityid: "1", cityname: "patna")),
          (Route<dynamic> route) => false,
    );


  }

  Future<String> Checkreferral() async {


    var jsonData = await http.get("https://biographydad.com/api/checkrefral/${enteredreferral.text}");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      if (data.length != 0) {
        data.forEach((element) {
          Referreduser=element["user_id"];
          referal=true;
          makePostRequest();

          Fluttertoast.showToast(msg: "Referral Matched....");


        });




      }
      else {
        print("no");
        Fluttertoast.showToast(msg: "Referral Does Not Match");
      }




      _progressBarActive=false;
    });
    return "Success";
  }

  Future<String> addmoney(userid,amount) async {

    var jsonData = await http.get("https://biographydad.com/api/transactin/$userid/$amount/2");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];

      _progressBarActive=false;
    });
    print("vvvvvvvvvvv${data.length}");
    if (data.length != 0) {
      setState(() {


      });


    }

    return "Success";
  }
}
