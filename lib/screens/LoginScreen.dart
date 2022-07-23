
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/constant/constant.dart';
import 'package:go_fit_now/screens/entryform.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String phoneNumber, verificationId;
  late String otp, authStatus = "";
  final _formKey = GlobalKey<FormState>();
  final mobilenum = TextEditingController();
  List data=[];
  late String username;
  bool _progressBarActive=false;



  Future<void> verifyPhoneNumber(BuildContext context) async {

        otpDialogBox(context).then((value) {});

  }



  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.only(right: 8.0,left: 8.0,top: 8.0,bottom: 70.0),
              child: _progressBarActive == true
                  ? Container(
                  height: 60,
                  child: Center(

                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.red,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )))
                  :OTPTextField(
                length: 4,
                width: (MediaQuery.of(context).size.width)/2,
                fieldWidth: 40,
                style: TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) async {
                  print("OTP entered: " + pin);

                  if (pin == '1111') {
                    print("otp verified");
                    setState(() {
                      _progressBarActive=true;
                    });
                    Fluttertoast.showToast(msg: "OTP verified");



                    checkuser();

                  } else {
                    print("wrong otp");
                    Fluttertoast.showToast(msg: "Wrong OTP");
                  }
                },
              ),

            ),
            contentPadding: EdgeInsets.all(10.0),


          );
        });
  }

  Future<String> checkuser() async {


    var jsonData = await http.get("https://biographydad.com/api/useridcheck/${mobilenum.text}");
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


        });
      });

      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      prefs.setString('userid', mobilenum.text);
      Fluttertoast.showToast(
          msg: "Welcome back $username");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(cityid: "1", cityname: "patna")),
            (Route<dynamic> route) => false,
      );
    }
    else {
      Fluttertoast.showToast(
          msg: "Welcome To Go Fit Now");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => EntryForm(mobnum: mobilenum.text),
        ),
        (Route<dynamic> route) => false,
      );
    }
    return "Success";
  }



  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
      body: SingleChildScrollView(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              


              Container(
                margin: EdgeInsets.all(10),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fill
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                "Phone Verification",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  validator: (value) {

                    if (value == null || value.isEmpty ) {
                      Fluttertoast.showToast(msg: 'Please Enter Mobile Number');
                      return 'Please Enter Mobile Number';
                    }
                    else if (value.length!=10 ) {
                      Fluttertoast.showToast(msg: 'Please Enter Valid Number');
                      return 'Please Enter Valid Number';
                    }
                    return null;
                  },
                  controller: mobilenum,
                  maxLength: 10,

                  keyboardType: TextInputType.number,

                  showCursor: true,


                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF666666),

                    ),
                      fillColor: Colors.white70,
                    hintStyle: TextStyle(
                      color: Color(0xFF666666),

                    ),
                    hintText: "Enter Mobile Number",
                  ),
                ),
                // TextField(
                //   keyboardType: TextInputType.phone,
                //   decoration: new InputDecoration(
                //       border: new OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(
                //           const Radius.circular(30),
                //         ),
                //       ),
                //       filled: true,
                //       prefixIcon: Icon(
                //         Icons.phone_iphone,
                //         color: Colors.cyan,
                //       ),
                //       hintStyle: new TextStyle(color: Colors.grey[800]),
                //       hintText: "Enter Your Phone Number...",
                //       fillColor: Colors.white70),
                //   onChanged: (value) {
                //     phoneNumber = value;
                //   },
                // ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    verifyPhoneNumber(context);
                  }
                },
                child: Text(
                  "Generate OTP",
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 7.0,
                color: Colors.cyan,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Need Help?"),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                authStatus == "" ? "" : authStatus,
                style: TextStyle(
                    color: authStatus.contains("fail") ||
                        authStatus.contains("TIMEOUT")
                        ? Colors.red
                        : Colors.green),
              )
            ],
          ),
        ),
      ),
    ));
  }
}