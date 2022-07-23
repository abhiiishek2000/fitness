import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_fit_now/constant/constant.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:go_fit_now/widgets/bottomnav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class mywallet extends StatefulWidget {
  const mywallet({Key? key}) : super(key: key);

  @override
  _mywalletState createState() => _mywalletState();
}

class _mywalletState extends State<mywallet> {

  final addmoneyamount  = TextEditingController();
  List data=[];
  List date_time=[];
  List transtype=[];
  List transAmount=[];
  late String userid;
  String wallet_amount="0";
  bool _progressBarActive=true;
  late Razorpay _razorpay;




  @override
  void initState() {
    super.initState();
    fetchtransation();
    fetchdatauser();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<String> fetchtransation() async {

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid')!;

    print(userid);

    var jsonData = await http.get("https://biographydad.com/api/viewtrans/$userid");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];

      _progressBarActive=false;
    });

    if (data.length != 0) {
      setState(() {
        data.forEach((element) {

          transAmount.add(element['amount']);
          transtype.add(element['transtion_type']);
          date_time.add(element['crated_at']);

        });

      });


    }

    return "Success";
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

          wallet_amount = element['wallet_amount'];


        });

      });


    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: appbarwidget(),

      body: _progressBarActive == true
          ? Container(
          height: size.height / 1.5,
          child: Center(
              child: const CircularProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              )))
          :Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(


          child: Column(
            children: <Widget>[
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/appbar.jpg'),
                      fit: BoxFit.cover
                  ) ,
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Current Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Rs.",
                              style: TextStyle(
                                color: Colors.white,
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
                                  color: Colors.white,
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
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFe67e22),
                        Color(0xFFf1c40f),
                      ],
                    ),
                  ),
                ),
              ),



              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[


                    // Expanded(
                    //   child: RaisedButton.icon(
                    //     onPressed: (){},
                    //     icon: Icon(FontAwesomeIcons.levelUpAlt, color: Color(0xff3498db),),
                    //     label: Text("Send"),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    // ),
                    //
                    // SizedBox(width: 20,),

                    Expanded(

                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                            controller: addmoneyamount,
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
                                Icons.monetization_on_outlined,
                                color: Color(0xFF666666),
                                size: 17,
                              ),
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: 'Roboto-Light.ttf',
                                fontSize: 14,
                              ),
                              hintText: "+Rs 1000",
                            ),
                          ),
                          SizedBox(height: 15,),
                          ButtonTheme(
                            buttonColor: Colors.green,
                            height: 50.0,
                            child:RaisedButton.icon(
                            onPressed: (){
                              razorpay();
                            },
                            icon: Icon(FontAwesomeIcons.moneyBill, color: Colors.white,),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Money",style: TextStyle(color: Colors.white),),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                    ),
                        ],
                      ),),

                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                padding: EdgeInsets.only(left: 20, top: 20),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 27,
                            width: 27,
                            color: Colors.green[900],
                            child: Icon(
                              FlutterIcons.history_faw,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Wallet History",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 30,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('View all'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 15),
                          child: SingleChildScrollView(
                            child: Container(
                              // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[

                              ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: date_time.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xffecf0f1),
                                        child: transtype[index]=="1"?Icon(Icons.add, color: Color(0xFF2980b9),):
                                        transtype[index]=="2"?Icon(Icons.money, color: Color(0xFF2980b9),):
                                        transtype[index]=="0"?Icon(Icons.payment, color: Color(0xFF2980b9),):null,
                                      ),
                                      title: transtype[index]=="1"?Text("Money Added"):
                                      transtype[index]=="2"?Text("Through Referral"):
                                      transtype[index]=="0"?Text("Payment"):null,
                                      trailing: Text("Rs.${transAmount[index]}",style: transtype[index]=="1"?TextStyle(color: Colors.green):
                                      transtype[index]=="2"?TextStyle(color: Colors.green):
                                      transtype[index]=="0"?TextStyle(color: Colors.red):null,),
                                    ),
                                  );}),

                                  SizedBox(height: 10,),


                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20,),
              //   alignment: Alignment.topLeft,
              //   child: Text("Currency", style: TextStyle(fontSize: 22,),),
              // ),
              //
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
              //   alignment: Alignment.topLeft,
              //   child: Column(
              //     children: <Widget>[
              //       Card(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: ListTile(
              //           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //           leading: CircleAvatar(
              //             backgroundColor: Color(0xffecf0f1),
              //             child: Icon(FontAwesomeIcons.bitcoin, color: Color(0xFFf1c40f),),
              //           ),
              //           title: Text("Bitcoin"),
              //           trailing: Text("\$8,000"),
              //         ),
              //       ),
              //
              //       SizedBox(height: 10,),
              //
              //       Card(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: ListTile(
              //           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //           leading: CircleAvatar(
              //             backgroundColor: Color(0xffecf0f1),
              //             child: Icon(FontAwesomeIcons.ethereum, color: Color(0xFF2980b9),),
              //           ),
              //           title: Text("Ethereum"),
              //           trailing: Text("\$450"),
              //         ),
              //       ),
              //
              //       SizedBox(height: 10,),
              //
              //       Card(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: ListTile(
              //           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //           leading: CircleAvatar(
              //             backgroundColor: Color(0xffecf0f1),
              //             child: Icon(FontAwesomeIcons.euroSign, color: Color(0xff2ecc71),),
              //           ),
              //           title: Text("Euro"),
              //           trailing: Text("\$99"),
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),
              //
              //
              // SizedBox(height: 100,),


            ],
          ),
        ),
      ),

        bottomNavigationBar: bottomnavwidget(selectedIndex: 0),
    );
  }


  void razorpay() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': int.parse(addmoneyamount.text) * 100,
      'name': 'Go Fit Now',
      'description': '',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
    print('${response.paymentId}');
    Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    addmoney();

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    addmoney();
    // orderconfirmed("ERROR: ");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
    addmoney();
    // orderconfirmed("EXTERNAL_WALLET: ");
  }
  Future<String> addmoney() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid')!;

    print(userid);

    var jsonData = await http.get("https://biographydad.com/api/transactin/$userid/${addmoneyamount.text}/1");
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
