import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart ' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OrderPass extends StatefulWidget {
  final String booking_id;

  OrderPass({Key? key, required this.booking_id}) : super(key: key);

  @override
  _OrderPassState createState() => _OrderPassState();
}

class _OrderPassState extends State<OrderPass> {
  late List data;
  List imagesUrl = [];
  List gymname = [];
  List location = [];
  List productprice = [];
  List productsellingprice = [];
  List <String>slot_time=[];
  List <String>slot_date=[];
  List payment_id=[];
  List amount_paid=[];
  List order_id=[];
  List booking_id=[];
  List gym=[];
  List yoga=[];
  List spa=[];
  List latitude=[];
  List longitude=[];
  String username="";
  String userid="";

  bool _progressBarActive = true;
  bool _noproduct = false;


  ScreenshotController screenshotController = ScreenshotController();

  late File _imageFile;

  Future getPdf(Uint8List screenShot) async {



    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
              child: pw.Image(PdfImage.file(pdf.document, bytes: screenShot), fit: pw.BoxFit.contain)
          );
        },
      ),
    );
    print(_localPath);
    File pdfFile = File('/data/user/0/Download');
    pdfFile.writeAsBytesSync(pdf.save());
    print("saved");
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }



  Future<String> fetchDataFromApi() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userid')!;
      username = prefs.getString('username')!;
    });

    Fluttertoast.showToast(msg: "Generating Pass");

    var jsonData = await http.get(
        "https://biographydad.com/api/getbookingdetails/${widget.booking_id}"); // product fetch based on catid,subcatid and session id
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
        gymname.add(element['name']);
        location.add(element['location']);
        slot_time.add(element['slot_time']);
        slot_date.add(element['slot_date']);
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
    markattendence();
    return "Success";
  }

  markattendence() async {

        var datetime=DateTime.now().toString();


        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        String? userid = prefs.getString('userid');

        final uri = Uri.parse('https://biographydad.com/api/insertatten');

        final headers = {'Content-Type': 'application/json'};
        Map<String, dynamic> body = {

          'user_id': userid,
          'gym_id': int.parse(widget.booking_id),
          'slot_time': slot_time,
          'atten_date': datetime,


          // 'created_by': null,
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

    Fluttertoast.showToast(msg: "Attendence Marked");


  }

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();



  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("ENTRY PASS"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {

              // screenshotController
              //     .capture(delay: Duration(milliseconds: 10))
              //     .then((capturedImage) async {
              //   showDialog(
              //     useSafeArea: false,
              //     context: context,
              //     builder: (context) => Scaffold(
              //       appBar: AppBar(
              //         title: Text("Captured widget screenshot"),
              //       ),
              //       body: Padding(
              //         padding: const EdgeInsets.all(18.0),
              //         child: Center(
              //             child: capturedImage != null
              //                 ? Image.memory(capturedImage)
              //                 : Container()),
              //       ),
              //     ),
              //   );
              //
              // });
              screenshotController.capture().then((value) {

                // setState(() {
                //   _imageFile = value as File;
                // });

                getPdf(value!);
              }).catchError((onError) {
                print(onError);
              });
            },
          )
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: _progressBarActive == true
            ? Container(
            height: size.height / 1.5,
            child: Center(
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )))
            :Container(

          child: Stack(


            children: <Widget>[
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.brown,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Container(

                  height: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 7.0,
                          offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xfff7f9ff)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 25.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.orange, Color(0xfff7f9ff)],
                            ),
                          ),
                          child: Column(
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0),
                                height: 100,
                                child: Stack(
                                  children: <Widget>[
                                    // Positioned.fill(
                                    //   child: Image.network("https://www.pixelstalk.net/wp-content/uploads/2016/06/Free-Desktop-Fitness-Wallpapers-HD.jpg",fit: BoxFit.cover,),
                                    // ),
                                    Positioned.fill(
                                      child: Container(
                                        margin: EdgeInsets.all(0),
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
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(child: Column(
                            children: <Widget>[
                              Text(
                                "Gym Name",
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                gymname[0],
                                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),),
                          Expanded(child: Column(
                            children: <Widget>[
                              Text(
                                "Booking Id",
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                booking_id[0],
                                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),),

                        ],),
                        SizedBox(height: 20,),
                        Row(children: <Widget>[

                          Expanded(child: Column(
                            children: <Widget>[
                              Text(
                                "Slot Date",
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                slot_date[0],
                                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),),
                          Expanded(child: Column(
                            children: <Widget>[
                              Text(
                                "Slot Time",
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                slot_time[0],
                                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),),
                        ],),
                        SizedBox(height: 20,),
                        Row(children: <Widget>[

                          Expanded(child: Column(
                            children: <Widget>[
                              Text(
                                "Gym Location",
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  location[0],
                                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),),
                          Expanded(child: Container(),),
                        ],),



                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          padding: const EdgeInsets.all(15.0),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage("imageUrl"),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  FittedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          username,
                                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          userid,
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 3,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff1f2f9),
                                        borderRadius: BorderRadius.circular(3.0)),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.airline_seat_recline_normal),
                                        gym[0]=="1"?Text("G-${booking_id[0]}"):
                                        yoga[0]=="1"?Text("G-${booking_id[0]}"):
                                        spa[0]=="1"?Text("G-${booking_id[0]}"):
                                            Text("null"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(),

                            ],
                          ),
                        ),
                        Image.network("https://barcode.tec-it.com/barcode.ashx?data=This+is+a+PDF417+by+TEC-IT&code=PDF417&dpi=96&dataseparator="),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}




