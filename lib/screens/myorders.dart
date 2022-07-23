
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_fit_now/screens/order_pass.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Myorders extends StatefulWidget {
  const Myorders({Key? key}) : super(key: key);

  @override
  _MyordersState createState() => _MyordersState();
}

class _MyordersState extends State<Myorders> {

  late List data;
  List imagesUrl = [];
  List productname = [];
  List location = [];
  List productprice = [];
  List productsellingprice = [];
  List <String>slot_time=[];
  List <String>slot_date=[];
  List payment_id=[];
  List qrcode=[];
  List amount_paid=[];
  List order_id=[];
  List booking_id=[];
  List gym=[];
  List yoga=[];
  List spa=[];
  List latitude=[];
  List longitude=[];
  List datepassed=[];



  bool _progressBarActive = true;
  bool _noproduct = false;

  late double _width;
  late double _height;

  Future<String> fetchDataFromApi() async {
   SharedPreferences prefs;
   prefs = await SharedPreferences.getInstance();
   String? userid = prefs.getString('userid');          // getting session id from main.dart(splash screen)
    var jsonData = await http.get(
        "https://biographydad.com/api/getbooking/$userid"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      print(data);
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
        slot_time.add(element['slot_time']);
        slot_date.add(element['slot_date']);


//        --------------------------USE THIS FEATURE IF YOU WANT TO CHECK SLOT DATE PASSED OR PENDING-------------------------------------------------------------------

        // if(element['slot_date'].compareTo(DateFormat('dd-MMM-yyyy').format(DateTime.now()).toString())>0){
        //   datepassed.add(true);
        // }
        // else{
        //   datepassed.add(false);
        // }

        qrcode.add(element['admin_userid']+"@gofitnow");
        payment_id.add(element['payment_id']);
        amount_paid.add(element['total_amount']);
        order_id.add(element['order_id']);
        booking_id.add(element['booking_id']);
        gym.add(element['gym']);
        yoga.add(element['yoga']);
        spa.add(element['spa']);
        latitude.add(element['latitude']);
        longitude.add(element['longitude']);


        productsellingprice.add(element['offer_price'].toString());
        productprice.add(element['selling_price'].toString());






        _progressBarActive = false;
      });
    });
    return "Success";
  }


  @override
  void initState() {
    super.initState();
    fetchDataFromApi();


  }


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appbarwidget(),
      // drawer: drawerwidget(),
        backgroundColor: Colors.grey[100],
        body: Scaffold(
          appBar: AppBar(centerTitle: true,title: Text("My Bookings",style: TextStyle(color: Colors.white),),backgroundColor: Colors.orange,leading: Container(),),

          // AppBar(
          //   backwardsCompatibility: false,
          //   systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
          //   backgroundColor: Colors.orange,
          //   centerTitle: true,
          //   title: Text(
          //     "My Bookings",
          //     textAlign: TextAlign.center,
          //   ),
          // ),
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
                SizedBox(height: 10,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: imagesUrl.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: GestureDetector(
                        onTap: () {

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
                                          SizedBox(height: 3,),
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
                                            "Amount Paid : ${amount_paid[index]}",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                              "Booking Id : ${booking_id[index]}",
                                              style: TextStyle(color: Colors.red,
                                                  )),
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
                                            "Slot Date :- ${slot_date[index]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Timing :- ${slot_time[index]}",
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
                                        Badge(
                                          position: BadgePosition.bottomStart(bottom: -15, start: -15),
                                          animationDuration: Duration(milliseconds: 2000),
                                          animationType: BadgeAnimationType.slide,
                                          badgeContent:Container(
                                            width: 40.0,
                                            height: 40.0,
                                            child: Image.asset("assets/images/approved_stamp.png"),
                                            decoration: new BoxDecoration(
                                              color: Colors.yellow,
                                              shape: BoxShape.circle,
                                            ),
                                          ),

                                          child: Card(
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
                            SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:0, vertical: 5),
                              child: FlatButton(
                                padding: EdgeInsets.all(13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                color: Color(0xFFF5F6F9),
                                onPressed: (){
                                  openMap(double.parse(latitude[index]),double.parse(longitude[index]));
                                },
                                child: Row(
                                  children: [

                                    Icon(Icons.location_on,color: Color(0xFF666666),),
                                    SizedBox(width: 20),
                                    Expanded(child: Text("Tap to View in Map",style: TextStyle(fontWeight:FontWeight.w400,color: Color(0xFF666666)),)),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            ),
                            // datepassed[index]?
                            slot_date[index].compareTo(DateFormat('dd-MMM-yyyy').format(DateTime.now()).toString())==0?
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:0, vertical: 5),
                              child: FlatButton(
                                padding: EdgeInsets.all(13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                color: Color(0xFFF5F6F9),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QRViewExample(qrcode: qrcode[index],bookingid: booking_id[index],),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [

                                    Icon(Icons.camera_alt,color: Color(0xFF666666),),
                                    SizedBox(width: 20),
                                    Expanded(child: Text("Scan QR To Generate Pass",style: TextStyle(fontWeight:FontWeight.w400,color: Color(0xFF666666)),)),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            ):
                            Container(),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal:0, vertical: 5),
                            //   child: FlatButton(
                            //     padding: EdgeInsets.all(13),
                            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            //     color: Color(0xFFF5F6F9),
                            //     onPressed: (){
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => OrderPass(booking_id: booking_id[index],),
                            //         ),
                            //       );
                            //     },
                            //     child: Row(
                            //       children: [
                            //
                            //         Icon(Icons.picture_as_pdf_sharp,color: Color(0xFF666666),),
                            //         SizedBox(width: 20),
                            //         Expanded(child: Text("Generate Pass",style: TextStyle(fontWeight:FontWeight.w400,color: Color(0xFF666666)),)),
                            //         Icon(Icons.arrow_forward_ios),
                            //       ],
                            //     ),
                            //   ),
                            // )
                            // :Container(),

                          ]),
                        ),
                      ),
                    );
                  },
                ),


              ],
            ),
          ),
          backgroundColor: Colors.grey[100],
        ),
        );
  }


  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}




class QRViewExample extends StatefulWidget {
  final String qrcode;
  final String bookingid;
  const QRViewExample({Key? key, required this.qrcode,required this.bookingid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}


class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  String barcode="";
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = 300.0;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              overlayMargin:EdgeInsets.all(30),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              cameraFacing: CameraFacing.back,
              formatsAllowed: [BarcodeFormat.qrcode],
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Access Denied! Please Try Again',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                  : Text('Scan a code',style: TextStyle(color: Colors.indigoAccent,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(widget.qrcode);
      barcode=scanData.code;
      print(barcode);
      print(widget.qrcode==barcode);
      if(widget.qrcode==barcode){
        dispose();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPass(booking_id: widget.bookingid,),
          ),
        );

      }
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

