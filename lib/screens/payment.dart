import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/screens/myorders.dart';
import 'package:go_fit_now/screens/mywallet.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:go_fit_now/widgets/drawerwidget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class payment extends StatefulWidget {
  final String service_id;
  final String selected_date;
  final String selected_slot;
  payment({Key? key, required this.service_id, required this.selected_date, required this.selected_slot}) : super(key: key);

  @override
  _paymentState createState() => _paymentState();
}

class _paymentState extends State<payment> {

  late Razorpay _razorpay;
  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;


  late List data;
  List imagesUrl = [];
  List productname = [];
  List location = [];
  List productprice = [];
  List productsellingprice = [];
  List seat_left=[];
  String appliedpromocode="";
  late String userid;
  late String wallet_amount="0.00";


  List productunit = [];
  List productstock = [];
  List productid = [];
  List productqtyordered = [];
  List orderdate = [];
  String coupondiscount ="0";
  String couponwarning="Promocode Unavailabe";
  late String minimunamountforcoupon;

  bool _progressBarActive = true;
  bool _promocodeprogressBarActive = false;
  bool wrongpromocode=false;
  bool _noproduct = false;
  bool promocodeapplied=false;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
    fetchwalletamount();
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

  Future<String> fetchwalletamount() async {

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


  Future<String> checkcouponcode(String promocode) async {

    var jsonData = await http.get(
        "https://biographydad.com/api/promocodecoupons/$promocode"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      var pitem = data.length;
      if (pitem != 0) {
        setState(() {
          appliedpromocode=promocode;
          wrongpromocode=false;
          promocodeapplied=true;
        });
        print("yes");
      } else {
        print("no");
        setState(() {
          promocodeapplied=false;
          wrongpromocode=true;
          _promocodeprogressBarActive = false;

        });
      }
      data.forEach((element) {

        setState(() {
          minimunamountforcoupon=element['min_amount'].toString();
          if(int.parse(productsellingprice[0])>=int.parse(minimunamountforcoupon)){
            coupondiscount=element['max_discount'].toString();
            appliedpromocode=promocode;
            wrongpromocode=false;
            promocodeapplied=true;
          }
          else{
            Fluttertoast.showToast(msg: "Minimum Amount For this PromoCode Is Rs. $minimunamountforcoupon");
            couponwarning="Minimum Amount For this PromoCode Is Rs. $minimunamountforcoupon";
            promocodeapplied=false;
            wrongpromocode=true;
            coupondiscount ="0";
          }
        });

        
        // imagesUrl.add(element['image']);

        _promocodeprogressBarActive = false;
      });
    });
    return "Success";
  }


  Future<String> fetchDataFromApi() async {
//    SharedPreferences prefs;
//    prefs = await SharedPreferences.getInstance();
//    String userid = prefs.getString('userid');          // getting session id from main.dart(splash screen)
    var jsonData = await http.get(
        "https://biographydad.com/api/service/${widget.service_id}"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      var pitem = data.length;
      if (pitem != 0) {
        print("yes");
      } else {
        print("no");
        setState(() {
          _progressBarActive = false;
          _noproduct = true;
        });
      }
      data.forEach((element) {
        imagesUrl.add(element['img_path']);
        productname.add(element['name']);
        location.add(element['location']);
        productsellingprice.add(element['offer_price'].toString());
        productprice.add(element['selling_price'].toString());
        seat_left.add(element['seat_left']);
        productid.add(element['id'].toString());
        productqtyordered.add(element['qty'].toString());
        orderdate.add(element['date'].toString());
        _progressBarActive = false;
      });
    });
    return "Success";
  }

  orderconfirmed(String Paymentid) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');

    final uri = Uri.parse('https://biographydad.com/api/insertorder/${widget.service_id}/${widget.selected_slot}/${widget.selected_date}');

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'user_id':userid,
      'gym_id': int.parse(widget.service_id),
      'slot_date':widget.selected_date,
      'slot_time':widget.selected_slot,
      'total_amount':int.parse(productsellingprice[0])-int.parse(coupondiscount),
      'payment_id': Paymentid,
      'address': "t"

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

    setState(() {
      _progressBarActive = false;
    });
    Fluttertoast.showToast(msg: "Session Booked...");



    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => DateTimeEntryForm(gymid: data["Last_id"])
    //   ),
    // );
  }

  late double _width;
  late double _height;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        // appBar: appbarwidget(),
        // drawer: drawerwidget(),
        backgroundColor: Colors.grey[100],
        body: Scaffold(
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
            backgroundColor: Colors.orange,
            title: Text(
              "Payment Page",
              textAlign: TextAlign.center,
            ),
          ),
          body: _progressBarActive == true
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: _progressBarActive,
                          child: ListView.builder(
                            itemBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
//                          width: 48.0,
//                          height: 48.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: size.width / 3,
                                                height: 16.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0),
                                              ),
                                              Container(
                                                width: size.width / 4,
                                                height: 14.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: size.width / 4,
                                                height: 10.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            height: 120.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            itemCount: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _noproduct == true
                  ? Container(
                      child: Center(child: new Text("no product found")))
                  : SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: imagesUrl.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: GestureDetector(
                                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => productpage(             // redirecting to productdetails.dart by passing product id
//                          id: '${productid[index]}',
//                        ),
//                      ),
//                    );
                                  },
                                  child: Container(
                                    child: Column(children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      productname[index],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),

                                                    Text(
                                                      "Offer Price : ${productsellingprice[index]}",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "Regular Price : ${productprice[index]}",
                                                        style: TextStyle(color: Colors.red,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),

                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Location :- ${location[index]}",
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Slot Date :- ${widget.selected_date}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Timing :- ${widget.selected_slot}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),

                                                  ],
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Card(
                                                    elevation: 4.0,
                                                    color: Colors.grey[900],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.white70,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Image.network(
                                                      imagesUrl[index],
                                                      width: size.width / 3,
                                                      height: size.height / 6,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15.0,)
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Have A Promo Code?',
                              style: TextStyle(),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (value) {
                                      setState(() {
                                        _promocodeprogressBarActive=true;
                                      });
                                      checkcouponcode(value);
                                      print("search $value");
                                    },
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Promo Code',
                                      prefixIcon: Icon(Icons.local_offer_outlined),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(12.0)),
                                        // borderSide: BorderSide(color: Colors.green, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: ButtonTheme(
                              //
                              //       height: 50.0,
                              //       child: RaisedButton(
                              //         onPressed: () {},
                              //         child: Text("Apply",style: TextStyle(color: Colors.white),),
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          _promocodeprogressBarActive == true?Container(child:Center(child: const CircularProgressIndicator(backgroundColor: Colors.red,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),))):Visibility(
                            visible: wrongpromocode,
                              child: Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child: Text(couponwarning,style: TextStyle(color: Colors.red),),
                              ),
                          ),
                          Visibility(
                            visible: promocodeapplied,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading: Icon(Icons.check_circle,color: Colors.green,),
                                        title: Text("Coupon Code Successfully Applied",style: TextStyle(fontWeight: FontWeight.bold),),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top:8.0),
                                          child: Text(
                                            "$appliedpromocode",
                                            style:
                                            TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        )),


                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
          backgroundColor: Colors.grey[100],
        ),
        bottomNavigationBar: _progressBarActive == true
            ? Container(height: size.height / 12, child: Container())
            : _noproduct == true
                ? SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('HOME_SCREEN');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.home), Text("Shop Now")],
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                  )
                : SizedBox(height: 153, child: _checkoutSection()));
  }

  Widget _checkoutSection() {
    return Material(
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Passes:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "Rs. ${productsellingprice[0]}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              )),
          // Padding(
          //     padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          //     child: Row(
          //       children: <Widget>[
          //         Text(
          //           "GST %:",
          //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          //         ),
          //         Spacer(),
          //         Text(
          //           "Rs. 23",
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //         )
          //       ],
          //     )),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Promo Code:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "- Rs. ${coupondiscount}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total Amount:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "Rs. ${int.parse(productsellingprice[0])-int.parse(coupondiscount)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              )),
          // Padding(
          //     padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          //     child: Row(
          //       children: <Widget>[
          //         Text(
          //           "Product Quantity:",
          //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          //         ),
          //         Spacer(),
          //         Text(
          //           "5",
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //         )
          //       ],
          //     )),
          SizedBox(height: 6,),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        paybywallet();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payments_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Pay By Wallet",
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        openCheckout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payments_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Pay Now",
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0),
          //   child: Material(
          //     color: Colors.green,
          //     elevation: 2.0,
          //     child: InkWell(
          //       splashColor: Colors.greenAccent,
          //       onTap: () {
          //         openCheckout();
          //       },
          //       child: Container(
          //         width: double.infinity,
          //         child: Padding(
          //           padding: const EdgeInsets.all(17.5),
          //           child: Text(
          //             "Place Order",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w700),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<String> paybywallet() async {
    if(double.parse(wallet_amount)>=int.parse(productsellingprice[0])-int.parse(coupondiscount)){
      Fluttertoast.showToast(msg: "Paying from wallet");
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid')!;

      print(userid);

      var jsonData = await http.get("https://biographydad.com/api/transactin/$userid/${int.parse(productsellingprice[0])-int.parse(coupondiscount)}/0");
      print("mmmmm");
      var fetchData = jsonDecode(jsonData.body);
      print("cccccc");

      orderconfirmed("by wallet");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Myorders()),
            (Route<dynamic> route) => false,
      );

      return "Success";
    }
    else{
      print(double.parse(wallet_amount));
      print(int.parse(productsellingprice[0])-int.parse(coupondiscount));
      Fluttertoast.showToast(msg: "Please add some money in wallet");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mywallet(),
        ),
      );
    }


    return "Success";
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': int.parse(productsellingprice[0]) * 100,
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
    orderconfirmed(response.paymentId!);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    orderconfirmed("ERROR: ");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
    orderconfirmed("EXTERNAL_WALLET: ");
  }
}
