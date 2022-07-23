import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_fit_now/home/gym_page.dart';
import 'package:go_fit_now/home/model/category_model.dart';
import 'package:go_fit_now/home/spa_page.dart';
import 'package:go_fit_now/home/yoga_page.dart';
import 'package:go_fit_now/widgets/drawerwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../new_search/new_searchlocation.dart';
import '../widgets/bottomnav.dart';
import 'component/fit_home.dart';
import 'model/activity_model.dart';



class Intro {
  final String image;
  final String header;
  final Color color;

  Intro(this.image, this.header,this.color);
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,required this.cityid,required this.cityname}) : super(key: key);
  final String cityid;
  final String cityname;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 List<String> bannerList= ['banner_1','banner_2','banner-3'];
 late double _width;
 late double _height;
 List gyms=[];
 List spa=[];
 bool _spaprogressBarActive = true;
 List yoga=[];
 bool _yogaprogressBarActive = true;
 bool _yoganoproduct = false;
 bool _gymprogressBarActive = true;
 bool _gymnoproduct = false;
 final scaffoldKey = GlobalKey<ScaffoldState>();

 String userid ="";
 String username ='';
 @override
  void initState() {
   fetchdatauser();
    super.initState();
  }

 Future<String> fetchdatauser() async {

   SharedPreferences prefs;
   prefs = await SharedPreferences.getInstance();
   setState(() {
     userid = prefs.getString('userid')!;
     username = prefs.getString('username')!;
   });



   return "Success";
 }


  @override
  Widget build(BuildContext context) {
    var listIntros = <Widget>[
      CatItem(
          data: Intro("assets/images/gym.png", "Reverse \nworkout",Color(0xff625986)
              )),
      CatItem(
          data: Intro("assets/images/workout.png", "Workout \nat Home",Color(0xff90b8fd))),
      CatItem(
          data: Intro("assets/images/privacy-policy.png", "Consult \nour Neutralist",Color(0xffff8fab))),
      CatItem(
          data: Intro("assets/images/workout.png", "Workout \nat Home",Color(0xff90b8fd))),
      CatItem(
          data: Intro("assets/images/privacy-policy.png", "Consult \nour Neutralist",Color(0xffff8fab)))
    ];
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: bottomnavwidget(selectedIndex: 1),
      drawer: drawerwidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading : Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
              children:[
                IconButton(onPressed: ()=>scaffoldKey.currentState?.openDrawer(), icon: Icon(Icons.menu_outlined,color: Colors.black,)),
                // Image.asset("assets/images/ic_user.png"),

          ]),
        ),
       title: Text('Hi, $username',style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),
       ),
        // actions: [
        //   // IconButton(onPressed: ()=> Navigator.push(
        //   //   context,
        //   //   MaterialPageRoute(
        //   //     builder: (context) => newcitysearch(isFromGYM: true,isFromSapa: false,isFromYoga: false),
        //   //   ),
        //   // ), icon: Icon(Icons.search,color: Colors.black,))
        // ],

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: MediaQuery.of(context).size.height*0.24,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: bannerList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset("assets/images/${bannerList[index]}.jpg"),
                      ),
                    );
                  }),
            ),
            Container(
              child: GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),

                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: Categorys.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                   return InkWell(
                     onTap: (){
                       if(index==0){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>GymPage(cityname: "patna", cityid: "1")));
                       }else if(index==1){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>YogaScreen(cityname: "patna", cityid: "1")));
                       }else if(index==2){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>SpaScreen(cityname: "patna", cityid: "1")));
                       }
                       else{
                         Fluttertoast.showToast(msg: "Coming Soon...");
                       }
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         color: Categorys[index].color,
                         borderRadius: BorderRadius.circular(10)
                       ),
                       child: Column(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.max,
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Text("${Categorys[index].title}",style: GoogleFonts.roboto(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                               Image.asset("assets/images/${Categorys[index].image}",height: 48,color: index==3 ||index==4||index==5?  null:Colors.white,)
                             ],
                           )
                         ],
                       ),
                     ),
                   );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16),
              child: Text('TRACK YOUR ACTIVITIES',style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w600,wordSpacing: 2),),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: MediaQuery.of(context).size.height*0.16,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: ActivityList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: MediaQuery.of(context).size.width*0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            offset: Offset(0,0.3),
                            blurRadius: 6,

                          )
                        ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: ActivityList[index].color,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/${ActivityList[index].image}",height: 24,color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 16,),
                          Text(ActivityList[index].title,style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 10),)
                        ],
                      ),

                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16),
              child: Text('Stay fit @home',style: GoogleFonts.roboto(fontSize: 18,fontWeight: FontWeight.w900,wordSpacing: 2),),
            ),
            FitAtHome()
          ],
        ),
      ),
    );
  }
}
class CatItem extends StatelessWidget {
  const CatItem({Key? key,required this.data}) : super(key: key);
  final Intro data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
       margin: EdgeInsets.symmetric(horizontal: 8),
         decoration: BoxDecoration(
           color: data.color,
           borderRadius: BorderRadius.circular(5),
         ),
      child: Row(
        children: [
          Image.asset(data.image,color: Colors.white,height: 32,),
          SizedBox(width: 6,),
          Text(data.header,style: GoogleFonts.roboto(fontSize: 12,color: Colors.white,fontWeight:FontWeight.w500),),

        ],
      ),
    );
  }
}

