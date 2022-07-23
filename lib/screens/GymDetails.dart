import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:go_fit_now/screens/payment.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/model/subscription_model.dart';


class gymdetails extends StatefulWidget {
  final String service_id;
  gymdetails({Key? key, required this.service_id}) : super(key: key);

  @override
  _gymdetailsState createState() => _gymdetailsState();
}

class _gymdetailsState extends State<gymdetails> {
  List data =[];
  List imagesmap =[];
  List imagesUrl=[];
  List <String>slot_time=[];
  List <String>slot_price=[];
  List <String>slot_capacity=[];
  List <String>slot_date=[];
  List<String> reportList = ["BCA", "MCA", "Other", "Experience", "Fresher"];
  List<String>  feature_points= [];
  late String productname;
  late String location;
  late String latitude;
  late String longitude;
  late String features;
  late String discription;
  late String productprice;
  late String productsellingprice;
  String seat_left="null";
  String seat_warning="";
  String selected_date="null";
  String selected_slot="null";
  bool seatfull=false;
  late String productstock;
  bool _progressBarActive =true;
  bool _loadslotprogressBarActive=true;
  String dob="Select Date";
  int currentIndex=0;

  late String selectedtimeslot;

  final List<String> imagesUrlnew = [
    "https://i.pinimg.com/736x/55/6d/ab/556dab1887090351f3901f5595830bfd.jpg",
    "https://i.pinimg.com/736x/55/6d/ab/556dab1887090351f3901f5595830bfd.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];






  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
    checkslot();

  }

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    setState(() {
      seat_warning="";
    });
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,

        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 7)));
    if (pickedDate != null && pickedDate != currentDate){
      setState(() {
        currentDate = pickedDate;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        dob = formattedDate;
      });
      _loadslotprogressBarActive=true;
      checkslot();

    }
  }


  Future<String> fetchDataFromApi() async {


    var jsonData = await http.get("https://biographydad.com/api/service/${widget.service_id}");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      data.forEach((element) {
        imagesUrl.add(element['img_path']);
        productname = element['name'];
        location = element['location'];
        latitude = element['latitude'];
        longitude = element['longitude'];
        seat_left = element['seat_left'];
        discription = element['discription'];
        features=element['feature_point'];
        productsellingprice = element['offer_price'].toString();
        productprice = element['selling_price'].toString();

        // productstock = element['stock'].toString();

      });
      imagesmap = fetchData['images'];
      imagesmap.forEach((element) {
        print("vvvvvvv${element['img_path']}");
        imagesUrl.add(element['img_path']);


      });
      if(features!=null){
        feature_points = features.split('\n');
      }

      _progressBarActive=false;
    });
    return "Success";
  }

  Future<String> checkslot() async {



    var jsonData = await http.get("https://biographydad.com/api/checkslot/${widget.service_id}/$dob");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      slot_time.clear();
      slot_price.clear();
      slot_capacity.clear();
      slot_date.clear();

      data = fetchData['Data'];
      print(data);
      print(DateTime.now());

      print(dob);

      if(dob.compareTo(DateFormat('dd-MMM-yyyy').format(DateTime.now()).toString())==0){
        // print("Current date selected");
        // String currenttime=DateTime.now().hour.toString()+":"+DateTime.now().minute.toString();
        var currenttime=DateFormat('hh:mm a').format(DateTime.now());
        data.forEach((element) {
          // print(element['slot_time'].substring(0,5));
          // print(currenttime);
          // print("Comparision: ${currenttime.compareTo(element['slot_time'].substring(0,5))}");

          if(currenttime.compareTo(element['slot_time'].substring(0,8))<=0){


            slot_time.add(element['slot_time']);
            slot_price.add(element['slot_price']);
            slot_capacity.add(element['slot_available']);
            slot_date.add(element['slot_date']);
          }


        });
      }
      else{
        data.forEach((element) {
          slot_time.add(element['slot_time']);
          slot_price.add(element['slot_price']);
          slot_capacity.add(element['slot_available']);
          slot_date.add(element['slot_date']);

        });
      }


      print("vvnnnnnnnnnnnn$slot_time");

      _loadslotprogressBarActive=false;
      _progressBarActive=false;
    });
    return "Success";
  }


  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: appbarwidget(),

          // drawer: DrawerWidget(),
          body: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _progressBarActive == true?Container(height: size.height/1.5,child:Center(child: const CircularProgressIndicator())):Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),


                    GFCarousel(
                      viewportFraction: 1.0,
                      aspectRatio: 1.5,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      items: imagesUrl.map(
                            (url) {
                          return Container(
                            margin: EdgeInsets.all(16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(
                                  url,
                                  fit: BoxFit.fitWidth,
                                  // width: 1600.0
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex=index;
                        });
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child:Center(
                              child:  Container(
                                height: 10,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imagesUrl.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: index != currentIndex ? 10 : 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: index != currentIndex
                                            ? Colors.grey.withOpacity(0.50)
                                            : Colors.orange,

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ]),




                    Column(
                      children: [
                        ListTile(
                          isThreeLine: true,
                        title: Text(productname,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                        subtitle: Row(
                          children: [
                            Icon(Icons.location_on,size: 14,),
                          SizedBox(width: 4,),
                          Text(
                            "$location",

                            style:
                            TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 12)),
                          ],
                        ),
                          trailing: Wrap(

                            children: <Widget>[
                             IconButton(onPressed: ()=>null, icon: Icon(Icons.call,color: Colors.indigo,)), // icon-1
                              IconButton(onPressed: ()=>null, icon: Icon(Icons.share,color: Colors.indigo)),
                              IconButton(onPressed: ()=>openMap(double.parse(latitude),double.parse(longitude)), icon: Icon(Icons.directions,color: Colors.indigo))// icon-2
                            ],
                          ),
                        ),


                    ],
                    ),
                    feature_points.length!=0?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.keyboard_arrow_down),
                          title: Text("Key Features",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),


                        for(var i = 0; i < feature_points.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(left:68.0),
                            child: Text("•  ${feature_points[i]}",style: TextStyle(),),
                          ),
                        SizedBox(height: 10,)

                      ],
                    ):Container(),
                    Column(
                      children: [
                        ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text("Description",style: TextStyle(fontWeight: FontWeight.w600),),
                            subtitle: Text(
                              discription,
                              style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                            )),



                      ],
                    ),

                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Offer Price Per Day",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Rs. $productsellingprice",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.green),
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Regular Day Price",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Rs. $productprice",
                                      style: TextStyle(fontSize: 14,color: Colors.red, fontWeight: FontWeight.w500,decoration:
                                      TextDecoration
                                          .lineThrough),
                                    )
                                  ],
                                )),
                            SizedBox(height: 15,)


                          ],
                        ),



                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.indigo,
                      ),
                      child: ListTile(
                        onTap: (){
                          _selectDate(context);
                          setState(() {
                            selected_date=dob;
                            selected_slot="null";
                          });

                        },
                        leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.5)
                          ),
                          child: Icon(Icons.calendar_today_outlined,color: Colors.white,size: 18,),
                        ),
                        title: Text("Tap to Select Date",style: GoogleFonts.roboto(color: Colors.white),),
                        subtitle: Text(dob,style: GoogleFonts.roboto(color: Colors.white,fontSize: 10,fontWeight: FontWeight.w300),),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                      ),

                    ),
                    // Card(
                    //     clipBehavior: Clip.antiAlias,
                    //     color: Colors.white,
                    //     child: Column(
                    //       children: [
                    //         GestureDetector(
                    //           onTap: (){
                    //             _selectDate(context);
                    //             setState(() {
                    //               selected_date=dob;
                    //               selected_slot="null";
                    //             });
                    //
                    //           },
                    //           child: ListTile(
                    //               leading: Icon(Icons.calendar_today),
                    //               title: Text('Tap To Select Date',style: TextStyle(fontWeight: FontWeight.bold),),
                    //               subtitle: Text(
                    //                 dob,
                    //                 style:
                    //                 TextStyle(color: Colors.black.withOpacity(0.6)),
                    //               )),
                    //         ),
                    //
                    //
                    //
                    //
                    //
                    //       ],
                    //     )),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Book A Timing Slot",
                          style:
                          TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //color: Colors.green,
                        width: MediaQuery.of(context).size.width,
                        //margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            if (_loadslotprogressBarActive == true) Container(child:Center(child: const CircularProgressIndicator())) else CustomRadioButton(
                              enableShape: true,
                              elevation: 0,
                              // defaultSelected: "Left",
                              enableButtonWrap: true,
                              width: 160,
                              autoWidth: false,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: slot_time,

                              buttonValues: slot_time,

                              radioButtonValue: (value) {
                                int index=slot_time.indexOf(value.toString());

                                setState(() {
                                  if(slot_capacity[index]=="0"){
                                    seatfull=true;
                                  }
                                  else{
                                    seatfull=false;
                                  }
                                  seat_left=slot_capacity[index];
                                  seat_warning="Hurry Up,Only $seat_left seats Left";
                                  selected_date=dob;
                                  selected_slot=slot_time[index];
                                });

                              },
                              selectedColor: Theme.of(context).accentColor,
                            ),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          seat_warning,
                          style:
                          TextStyle(color: Colors.red),
                        )),

                    SizedBox(
                      height: 8,
                    ),

                    GFCarousel(
                      viewportFraction: 1.0,
                      aspectRatio: 2,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      activeIndicator: Colors.yellowAccent,
                      items: subsList.map(
                            (details) {

                          return GestureDetector(
                            onTap: (){
                              Fluttertoast.showToast(msg: "Feature Coming Soon...");
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Colors.orange[400],
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter:
                                  ColorFilter.mode(Colors.black.withOpacity(0.09),
                                      BlendMode.darken),
                                  image: new AssetImage(
                                    details.imgPath,
                                  ),
                                ),
                              ),
                              // BoxDecoration(
                              //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              //     image: DecorationImage(
                              //         image: NetworkImage(
                              //           imagesUrl[0],
                              //             // "https://i.pinimg.com/736x/55/6d/ab/556dab1887090351f3901f5595830bfd.jpg",
                              //         ),
                              //         fit: BoxFit.cover
                              //     )
                              // ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex:2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:45.0,top: 20.0),
                                          child: Text(details.type,textAlign: TextAlign.center,style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Container(

                                      decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.7),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Offer Price",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rs. ${details.price}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              //   child: Image.network(
                              //     url,
                              //     fit: BoxFit.cover,
                              //
                              //     width: size.width/1.1
                              //   ),
                              // ),
                            ),
                          );
                        },
                      ).toList(),
                      onPageChanged: (index) {
                        setState(() {
                          // index;
                        });
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),



                  ],
                ),


              )),
          bottomNavigationBar: seatfull==true?SizedBox(
            height: 60,
            child: ElevatedButton(onPressed: (){

                Fluttertoast.showToast(msg: "Fully Booked, Please select Another Slot",backgroundColor: Colors.red);

            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning),
                Text("Fully Booked")
              ],
            ),
              style: ElevatedButton.styleFrom(primary: Colors.grey),),
          ):Container(
            margin: EdgeInsets.symmetric(horizontal:8,vertical: 8),
            height: 60,
            child: ElevatedButton(onPressed: (){
              if(selected_slot!="null" && selected_date!="null"){
                Fluttertoast.showToast(
                    msg: "Loading...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => payment(service_id: widget.service_id,selected_date: selected_date,selected_slot: selected_slot,),
                  ),
                );
              }
              else{
                Fluttertoast.showToast(msg: "Please Select Date and Time Slot");
              }


            }, child: Text("Book a Session"),
              style: ElevatedButton.styleFrom(primary: Colors.green),),
          )

      ),
    );

  }
}
