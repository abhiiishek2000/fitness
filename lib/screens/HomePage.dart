import 'dart:convert';
import'dart:math' as Math;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_fit_now/new_search/new_searchlocation.dart';
import 'package:go_fit_now/screens/searchlocation/searchlocation.dart';
import 'package:go_fit_now/widgets/GymHomeScreen.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:go_fit_now/widgets/bottomnav.dart';
import 'package:go_fit_now/widgets/drawerwidget.dart';
import 'package:go_fit_now/widgets/spahomescreen.dart';
import 'package:go_fit_now/widgets/yogahomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:stylish_dialog/stylish_dialog.dart';

import 'GymDetails.dart';


class HomePage extends StatefulWidget {
  final String cityid;
  final String cityname;

  HomePage({Key? key, required this.cityid, required this.cityname}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late double _width;
  late double _height;
  bool fetchinglocation=true;
  late String userid;
  late String username;
  List data=[];




//-----------------------------------------//gym page-------------------------------------------------------------------------------------------------
  late List gymdata;
  List gyms=[];
  late Position position;
  bool _gymprogressBarActive = true;
  bool _gymnoproduct = false;


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

  Future<String> gymfetchDataFromApi() async {
//    SharedPreferences prefs;
//    prefs = await SharedPreferences.getInstance();
//    String userid = prefs.getString('userid');          // getting session id from main.dart(splash screen)
    var jsonData = await http.get(
        "https://biographydad.com/api/gym_service/${widget.cityid}"); // product fetch based on catid,subcatid and session id
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      gymdata = fetchData['Data'];
      var pitem = gymdata.length;
      if (pitem != 0) {
        print("yes");
      }
      else {
        print("no");
        setState(() {
          _gymprogressBarActive = false;
          _gymnoproduct = true;
        });
      }
      gymdata.forEach((element) {
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
          "gymseatleft":(element['seat_left'].toString()),
          "gymid":(element['id'].toString()),

        };

        gyms.add(tmpArray);

        _gymprogressBarActive = false;
      });

      print(gyms);
    });
    return "Success";
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
    gymfetchDataFromApi();
    spafetchDataFromApi();
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


//-----------------------------------------//gym page-------------------------------------------------------------------------------------------------
//-----------------------------------------//yoga page-------------------------------------------------------------------------------------------------

  late List yogadata;
  List yoga=[];
  bool _yogaprogressBarActive = true;
  bool _yoganoproduct = false;


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
          "gymseatleft":(element['seat_left'].toString()),
          "gymid":(element['id'].toString()),

        };

        yoga.add(tmpArray);

        _yogaprogressBarActive = false;
      });

      print(yoga);
    });
    return "Success";
  }



//-----------------------------------------//yoga page-------------------------------------------------------------------------------------------------
//-----------------------------------------//spa page-------------------------------------------------------------------------------------------------
  late List spadata;
  List spa=[];
  bool _spaprogressBarActive = true;
  bool _spanoproduct = false;

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

//-----------------------------------------//spa page-------------------------------------------------------------------------------------------------

  void initState() {
    super.initState();
    getlocation();
    fetchdatauser();

  }



  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appbarwidget(),
      drawer: drawerwidget(),
      backgroundColor: Colors.grey[100],
      // backgroundColor: Colors.black26,

      body: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                bottom: TabBar(
                  onTap: (index) {
                    // Tab index when user select it, it start from zero
                  },
                  tabs: [
                    Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//                          Icon(Icons.card_travel),
//                          SizedBox(width: 3),
                          Text("GYM"),
                    ]),),

                    Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//                          Icon(Icons.card_travel),
//                          SizedBox(width: 3),
                          Text("YOGA",),
                        ]),),
                    Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
//                          Icon(Icons.card_travel),
//                          SizedBox(width: 3),
                          Text("SPA"),
                        ]),),
                  ],
                ),
                flexibleSpace: Container(
                    color: Colors.black54,
                    child: Container(
                      width: _width,
                      height: 55,
                      color: Colors.black,
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => newcitysearch(isFromGYM: true,isFromSapa: false,isFromYoga: false ),
                                ),
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 20,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(110)),
                                width: _width,
                                height: 45,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text("Your Location"),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.cityname,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Icon(Icons.arrow_drop_down_sharp),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
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
                                              _gymprogressBarActive=true;
                                              _yogaprogressBarActive=true;
                                              _spaprogressBarActive=true;

                                              gyms.sort((a, b) => a["distancebyme"]
                                                  .compareTo(b["distancebyme"]));
                                              yoga.sort((a, b) => a["distancebyme"]
                                                  .compareTo(b["distancebyme"]));
                                              spa.sort((a, b) => a["distancebyme"]
                                                  .compareTo(b["distancebyme"]));

                                              _gymprogressBarActive=false;
                                              _yogaprogressBarActive=false;
                                              _spaprogressBarActive=false;
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
                                              _gymprogressBarActive=true;
                                              _yogaprogressBarActive=true;
                                              _spaprogressBarActive=true;

                                              gyms.sort((a, b) => int.parse(a["offerprice"])
                                                  .compareTo(int.parse(b["offerprice"])));
                                              spa.sort((a, b) => int.parse(a["offerprice"])
                                                  .compareTo(int.parse(b["offerprice"])));
                                              yoga.sort((a, b) => int.parse(a["offerprice"])
                                                  .compareTo(int.parse(b["offerprice"])));

                                              _gymprogressBarActive=false;
                                              _yogaprogressBarActive=false;
                                              _spaprogressBarActive=false;
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
                                              _gymprogressBarActive=true;
                                              _yogaprogressBarActive=true;
                                              _spaprogressBarActive=true;

                                              gyms.sort((a, b) => int.parse(b["offerprice"])
                                                  .compareTo(int.parse(a["offerprice"])));
                                              spa.sort((a, b) => int.parse(b["offerprice"])
                                                  .compareTo(int.parse(a["offerprice"])));
                                              yoga.sort((a, b) => int.parse(b["offerprice"])
                                                  .compareTo(int.parse(a["offerprice"])));

                                              _gymprogressBarActive=false;
                                              _yogaprogressBarActive=false;
                                              _spaprogressBarActive=false;
                                            });

                                            // Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(110)),
                              width: _width,
                              height: 45,
                              alignment: Alignment.center,
                              child: Container(
                                // color: Colors.white,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.filter_alt_sharp,),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Sort By",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),



                            ),
                          ),
                        ),

                        // Expanded(
                        //   flex: 1,
                        //   child: GestureDetector(
                        //     onTap: (){
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => searchlocation(),
                        //         ),
                        //       );
                        //     },
                        //     child: Container(
                        //       margin: EdgeInsets.only(
                        //         top: 10,
                        //         left: 5,
                        //         right: 5,
                        //       ),
                        //       decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(110)),
                        //       width: _width,
                        //       height: 45,
                        //       alignment: Alignment.center,
                        //       child: Icon(
                        //         Icons.search,
                        //         size: 30,
                        //         color: Colors.grey,
                        //       ),
                        //
                        //
                        //
                        //     ),
                        //   ),
                        // ),



                      ]),
                    )),
              ),
              body: TabBarView(
                children: [
//-----------------------------------------//gym page-------------------------------------------------------------------------------------------------

                  (_gymprogressBarActive == true ?

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: _gymprogressBarActive,
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
                  _gymnoproduct == true ? Container(
                      child: Center(child: new Text("no product found"))) :
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _gymprogressBarActive=true;
                      });

                      gymfetchDataFromApi();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: gyms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => gymdetails(service_id: gyms[index]["gymid"].toString())
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

                                              Text(gyms[index]["gymname"],
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
                                                "Offer Price : ${gyms[index]["offerprice"]}",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("Regular Price : ${gyms[index]["normalprice"]}",
                                                  style: TextStyle(
                                                    color: Colors.red,
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
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => gymdetails(service_id: gyms[index]["gymid"].toString())
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View Details',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                ),
                                                style: ButtonStyle(
                                                  minimumSize: MaterialStateProperty.all(Size(160, 38)),
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Colors.teal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Location : ${gyms[index]["gymlocation"]}",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),

                                            ],
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 3,),
                                            Badge(
                                              position: BadgePosition.bottomStart(bottom: -10, start: -10),
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
                                                  gyms[index]["imagesUrl"],
                                                  width: size.width / 3,
                                                  height: size.height / 6,
                                                  fit: BoxFit.cover,
                                                ),
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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.location_on),
                                                  SizedBox(width: 2,),
                                                  Text(
                                                    "Dist near you : ${gyms[index]["distancebyme"]} Km"
                                                    ,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
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
                  )

                  ),



//-----------------------------------------//gym page-------------------------------------------------------------------------------------------------

//-----------------------------------------//yoga page-------------------------------------------------------------------------------------------------

                  _yogaprogressBarActive == true ? Container(
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
                  _yoganoproduct == true ? Container(
                      child: Center(child: new Text("no product found"))) :
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _yogaprogressBarActive=true;
                      });

                      yogafetchDataFromApi();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: yoga.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => gymdetails(service_id: yoga[index]["gymid"].toString())
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
                                              Text(yoga[index]["gymname"],
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
                                                "Offer Price : ${yoga[index]["offerprice"]}",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("Regular Price : ${yoga[index]["normalprice"]}",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                      decoration:
                                                      TextDecoration.lineThrough)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => gymdetails(service_id: gyms[index]["gymid"].toString())
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View Details',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                ),
                                                style: ButtonStyle(
                                                  minimumSize: MaterialStateProperty.all(Size(160, 38)),
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Colors.teal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Location : ${yoga[index]["gymlocation"]}",
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
                                            Badge(
                                              position: BadgePosition.bottomStart(bottom: -10, start: -10),
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
                                                  yoga[index]["imagesUrl"],
                                                  width: size.width / 3,
                                                  height: size.height / 6,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.location_on),
                                                  SizedBox(width: 2,),
                                                  Text(
                                                    "Dist near you : ${yoga[index]["distancebyme"]} Km"
                                                    ,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
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

//-----------------------------------------//yoga page-------------------------------------------------------------------------------------------------

//-----------------------------------------//spa page-------------------------------------------------------------------------------------------------
                  _spaprogressBarActive == true ? Container(
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
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _spaprogressBarActive=true;
                      });

                      spafetchDataFromApi();
                    },
                    child: ListView.builder(
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
                                                    color: Colors.red,
                                                      decoration:
                                                      TextDecoration.lineThrough)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => gymdetails(service_id: gyms[index]["gymid"].toString())
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View Details',
                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                ),
                                                style: ButtonStyle(
                                                  minimumSize: MaterialStateProperty.all(Size(160, 38)),
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Colors.teal,
                                                  ),
                                                ),
                                              ),
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

                                            ],
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 3,),
                                            Badge(
                                              position: BadgePosition.bottomStart(bottom: -10, start: -10),
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
                                                  spa[index]["imagesUrl"],
                                                  width: size.width / 3,
                                                  height: size.height / 6,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.location_on),
                                                  SizedBox(width: 2,),
                                                  Text(
                                                    "Dist near you : ${spa[index]["distancebyme"]} Km"
                                                    ,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
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


//-----------------------------------------//spa page-------------------------------------------------------------------------------------------------



                ],
              ),
            ),

        ),
      ),

      bottomNavigationBar: bottomnavwidget(selectedIndex: 1),
    );

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

    });
    print("vvvvvvvvvvv${data.length}");
    if (data.length != 0) {
      setState(() {
        data.forEach((element) {

          username = element['name'];

        });

      });

     prefs.setString('username', "${username}");


    }

    return "Success";
  }




}
