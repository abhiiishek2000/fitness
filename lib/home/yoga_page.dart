

import 'dart:convert';
import'dart:math' as Math;
import 'package:badges/badges.dart';
import 'package:go_fit_now/screens/GymDetails.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:go_fit_now/widgets/drawerwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

import '../new_search/new_searchlocation.dart';
import '../widgets/bottomnav.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({Key? key,required this.cityname,required this.cityid}) : super(key: key);
  final String cityid;
  final String cityname;

  @override
  _YogaScreenState createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  late List yogadata;
  List yoga=[];
  bool _yogaprogressBarActive = true;
  bool _yoganoproduct = false;
  late Position position;
  bool fetchinglocation=true;
  late double _width;
  late double _height;



  Future<String> yogafetchDataFromApi() async {
//    SharedPreferences prefs;
//    prefs = await SharedPreferences.getInstance();
//    String userid = prefs.getString('userid');          // getting session id from main.dart(splash screen)
    var jsonData = await http.get(
        "https://biographydad.com/api/yoga_service/${widget.cityid}"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      yogadata = fetchData['Data'];
      var pitem = yogadata.length;
      if (pitem != 0) {
        print("yes");
      }
      else {
        print("no");
        setState(() {
          _yogaprogressBarActive = false;
          _yoganoproduct = true;
        });
      }
      yogadata.forEach((element) {
        double gymlatitude=double.parse(element['latitude']);
        double gymlongitude=double.parse(element['longitude']);
        int nearbydistance=getDistanceFromLatLonInKm(gymlatitude,gymlongitude,position.latitude,position.longitude).round();


        Map tmpArray={
          "imagesUrl":(element['img_path']),
          "gymname":(element['name']),
          "gymlocation":(element['location'].toString()),
          "distancebyme": nearbydistance,
          "normalprice":(element['selling_price'].toString()),
          "offerprice":(element['offer_price'].toString()),
          "productunit":(element['unit']),
          "yogaeatleft":(element['seat_left'].toString()),
          "gymid":(element['id'].toString()),

        };

        yoga.add(tmpArray);

        _yogaprogressBarActive = false;
      });

      print(yoga);
    });
    return "Success";
  }
  double getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1);
    var a =
        Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
                Math.sin(dLon/2) * Math.sin(dLon/2)
    ;
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (Math.pi/180);
  }
  Future<void> getlocation() async {

    Position position1 = await _getGeoLocationPosition();
    setState(() {
      position=position1;
    });


    print(position.latitude);
    print(position.longitude);
    setState(() {
      fetchinglocation=false;
    });
    yogafetchDataFromApi();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

@override
  void initState() {

  getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
          bottomNavigationBar: bottomnavwidget(selectedIndex: 1),
        drawer: drawerwidget(),
        body:   _yogaprogressBarActive == true ? Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: _yogaprogressBarActive,
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
                              Expanded(flex: 1,child: Container(
                                width: double.infinity,
                                height: 120.0,
                                color: Colors.white,
                              ),),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
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
          _yoganoproduct == true ? Container(
          child: Center(child: new Text("no product found"))) :
          RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _yogaprogressBarActive=true;
          });

          yogafetchDataFromApi();
        },
        child: Column(
          children:[
            Container(
              margin:EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xffc7c7c7).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search Yoga..",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(8, 12, 12, 8)

                ),
                onChanged: (query) {
                  final searchResult =yoga.where((element) {
                    final moviesTitle = element['gymname'].toLowerCase();
                    final queryLoweCase = query.toLowerCase();

                    return moviesTitle.contains(queryLoweCase);
                  }).toList();

                  yoga = searchResult;

                  setState(() {});

                },


              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: yoga.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => gymdetails(service_id: yoga[index]["gymid"].toString())
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              offset: Offset(0,3),
                              blurRadius: 6,
                            )
                          ]
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,

                            children: [

                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [

                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              yoga[index]["imagesUrl"],
                                              width: size.width / 5,
                                              height: size.height / 10,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // Badge(
                                          //   position: BadgePosition.bottomStart(bottom: -10, start: -10),
                                          //   animationDuration: Duration(milliseconds: 2000),
                                          //   animationType: BadgeAnimationType.slide,
                                          //   badgeContent:Container(
                                          //     width: 40.0,
                                          //     height: 40.0,
                                          //     child: Image.asset("assets/images/approved_stamp.png"),
                                          //     decoration: new BoxDecoration(
                                          //       color: Colors.yellow,
                                          //       shape: BoxShape.circle,
                                          //     ),
                                          //   ),
                                          //
                                          //   child: ClipRRect(
                                          //     borderRadius: BorderRadius.circular(16),
                                          //     child: Image.network(
                                          //       yoga[index]["imagesUrl"],
                                          //       width: size.width / 3,
                                          //       height: size.height / 6,
                                          //       fit: BoxFit.cover,
                                          //     ),
                                          //   ),
                                          // ),

//                              Card( // with Card
//                                child: Image.network(imagesUrl[index]),
//                                elevation: 18.0,
//                                shape: CircleBorder(),
//                                clipBehavior: Clip.antiAlias,
//
//                              ),

                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(yoga[index]["gymname"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 4,
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


                                            Row(
                                              children: [
                                                Icon(Icons.location_on_outlined,color: Colors.black54,size: 16,),
                                                SizedBox(width: 4),
                                                Text(
                                                  "${yoga[index]["gymlocation"]}",
                                                  style: GoogleFonts.roboto(fontSize: 12),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Yoga",
                                              style: GoogleFonts.roboto(fontSize: 12),
                                            ),

                                          ],
                                        )),


                                  ],
                                ),
                              ),
                              Divider(color: Colors.black12,thickness: 0.5),

                              Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      "Price : ₹${yoga[index]["offerprice"]}",
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(" ₹${yoga[index]["normalprice"]}",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.red,
                                                            decoration:
                                                            TextDecoration.lineThrough)),
                                                  ],),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on,size: 16,),
                                                      SizedBox(width: 2,),
                                                      Text(
                                                        "${yoga[index]["distancebyme"]} Km"
                                                        ,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
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
            ),
        ]),
          )
      ),
    );
  }
  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: Offset(0,3),
                  blurRadius: 6
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => newcitysearch(isFromGYM: false,isFromSapa: false,isFromYoga: true),
                    ),
                  );
                },
                child: Row(children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin:
                    const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xff0000ffff),
                    ),
                    child: Icon(Icons.location_on),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(widget.cityname,
                      style: GoogleFonts.getFont(
                        'Roboto',
                        color: Color(0xFF000000),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      )),
                  Icon(Icons.keyboard_arrow_down),
                ],),
              ),
              Spacer(),
              IconButton(onPressed: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.location_on),
                            title: new Text('Sort By Near First'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                // _gymprogressBarActive=true;
                                _yogaprogressBarActive=true;
                                // _spaprogressBarActive=true;

                                // yoga.sort((a, b) => a["distancebyme"]
                                //     .compareTo(b["distancebyme"]));
                                yoga.sort((a, b) => a["distancebyme"]
                                    .compareTo(b["distancebyme"]));
                                // spa.sort((a, b) => a["distancebyme"]
                                //     .compareTo(b["distancebyme"]));

                                // _gymprogressBarActive=false;
                                _yogaprogressBarActive=false;
                                // _spaprogressBarActive=false;
                              });




                            },
                          ),
                          ListTile(
                            leading:
                            new Icon(Icons.monetization_on_outlined),
                            title: new Text('Price Low To High'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                // _gymprogressBarActive=true;
                                _yogaprogressBarActive=true;
                                // _spaprogressBarActive=true;

                                // yoga.sort((a, b) => int.parse(a["offerprice"])
                                //     .compareTo(int.parse(b["offerprice"])));
                                // spa.sort((a, b) => int.parse(a["offerprice"])
                                //     .compareTo(int.parse(b["offerprice"])));
                                yoga.sort((a, b) => int.parse(a["offerprice"])
                                    .compareTo(int.parse(b["offerprice"])));

                                // _gymprogressBarActive=false;
                                _yogaprogressBarActive=false;
                                // _spaprogressBarActive=false;
                              });

                              // Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading:
                            new Icon(Icons.monetization_on),
                            title: new Text('Price High To Low'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                // _gymprogressBarActive=true;
                                _yogaprogressBarActive=true;
                                // _spaprogressBarActive=true;

                                // yoga.sort((a, b) => int.parse(b["offerprice"])
                                //     .compareTo(int.parse(a["offerprice"])));
                                // spa.sort((a, b) => int.parse(b["offerprice"])
                                //     .compareTo(int.parse(a["offerprice"])));
                                yoga.sort((a, b) => int.parse(b["offerprice"])
                                    .compareTo(int.parse(a["offerprice"])));

                                // _gymprogressBarActive=false;
                                _yogaprogressBarActive=false;
                                // _spaprogressBarActive=false;
                              });

                              // Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }, icon: Icon(Icons.filter_alt_sharp))
            ],
          ),
        ),
      ),
    );
  }
}
