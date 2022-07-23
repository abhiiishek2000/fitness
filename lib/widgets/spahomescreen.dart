import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:go_fit_now/screens/GymDetails.dart';

import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';


class spahomescreen extends StatefulWidget {
  final String cityid;

  spahomescreen({Key? key, required this.cityid}) : super(key: key);
  @override
  _spahomescreenState createState() => _spahomescreenState();
}

class _spahomescreenState extends State<spahomescreen> {
  late List spadata;
  List spa=[];
  bool _spaprogressBarActive = true;
  bool _spanoproduct = false;

  @override
  void initState() {
    super.initState();
    spafetchDataFromApi();
  }




  Future<String> spafetchDataFromApi() async {
//    SharedPreferences prefs;
//    prefs = await SharedPreferences.getInstance();
//    String userid = prefs.getString('userid');          // getting session id from main.dart(splash screen)
    var jsonData = await http.get(
        "https://biographydad.com/api/spa_service/${widget.cityid}"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      spadata = fetchData['Data'];
      var pitem = spadata.length;
      if (pitem != 0) {
        print("yes");
      }
      else {
        print("no");
        setState(() {
          _spaprogressBarActive = false;
          _spanoproduct = true;
        });
      }
      spadata.forEach((element) {
        // double gymlatitude=double.parse(element['latitude']);
        // double gymlongitude=double.parse(element['longitude']);
        // int nearbydistance=getDistanceFromLatLonInKm(gymlatitude,gymlongitude,position.latitude,position.longitude).round();


        Map tmpArray={
          "imagesUrl":(element['img_path']),
          "gymname":(element['name']),
          "gymlocation":(element['location'].toString()),
          // "distancebyme": nearbydistance,
          "normalprice":(element['selling_price'].toString()),
          "offerprice":(element['offer_price'].toString()),
          "productunit":(element['unit']),
          "gymseatleft":(element['seat_left'].toString()),
          "gymid":(element['id'].toString()),

        };

        spa.add(tmpArray);

        _spaprogressBarActive = false;
      });

      print(spa);
    });
    return "Success";
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: _spaprogressBarActive == true ? Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: _spaprogressBarActive,
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
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                      width: size.width/3,
                                      height: 16.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    Container(
                                      width: size.width/4,
                                      height: 14.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: size.width/4,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 6.0),
                                    ),
                                    Container(
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(flex: 1,child: Container(
                                width: double.infinity,
                                height: 120.0,
                                color: Colors.white,
                              ),)
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
      ):
      _spanoproduct == true ? Container(
          child: Center(child: new Text("no product found"))) :
      ListView.builder(
        itemCount: spa.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => gymdetails(service_id: spa[index]["gymid"].toString())
                  ),
                );
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
                                Text(spa[index]["gymname"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  "Offer Price : ${spa[index]["offerprice"]}",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Regular Price : ${spa[index]["normalprice"]}",
                                    style: TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough)),
                                SizedBox(
                                  height: 10,
                                ),
//                                Text(
//                                  "Ordered Quantity: ${productqtyordered[index]}"
//                                  ,
//                                  style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 13,
//
//                                  ),
//                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Location : ${spa[index]["gymlocation"]}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
//                                paymentid[index] == "0" ? Text("Payment : COD",
//                                  style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 13,
//                                  ),
//                                ) :
//                                Text("Payment ID : ${paymentid[index]}",
//                                  style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 13,
//                                  ),
//                                ),
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              Card(
                                elevation: 4.0,
                                color: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                child: Image.network(
                                  spa[index]["imagesUrl"],
                                  width: size.width / 3,
                                  height: size.height / 6,
                                  fit: BoxFit.cover,

                                ),
                              ),
//                              Card( // with Card
//                                child: Image.network(imagesUrl[index]),
//                                elevation: 18.0,
//                                shape: CircleBorder(),
//                                clipBehavior: Clip.antiAlias,
//
//                              ),
                              SizedBox(height: 3,),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Container(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Hurry Up, Only : ${spa[index]["gymseatleft"]} seat left"
                                  ,
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontSize: 15,
                                  ),
                                ),
                              )),

                        ],
                      )),
                ]),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[100],

    );
  }
}




