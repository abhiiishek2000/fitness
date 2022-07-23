import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:go_fit_now/home/gym_page.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalTrainingScreen extends StatefulWidget {
  const PersonalTrainingScreen({Key? key}) : super(key: key);

  @override
  _PersonalTrainingScreenState createState() => _PersonalTrainingScreenState();
}

class _PersonalTrainingScreenState extends State<PersonalTrainingScreen> {

  List<String> images =[
    "assets/images/banner_1.jpg",
    "assets/images/banner_2.jpg",
    "assets/images/banner-3.jpg"
  ];
  List<String> des=[
    'ONE membership to 12,00+ gyms and trending group classes in india',
    'Customize your workout regime by switching between gyms,spa and yoga',
    'The only membership with complimentary 90 days pause'
  ];
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Personal Training",style: GoogleFonts.roboto(),),
        elevation: 0,
      ),
      bottomSheet: InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>GymPage(cityname: "Patna", cityid: "1"))),
        child: Container(
          width: size.width,
          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          height:44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orange,
          ),
          child: Center(child: Text("BUY NOW",style: GoogleFonts.roboto(fontWeight: FontWeight.w600,color: Colors.white),)),
        ),
      ),
      body: ListView(
        children: [
          GFCarousel(
            viewportFraction: 1.0,
            height: size.width,
            autoPlay: true,
            enableInfiniteScroll: true,
            items: images.map(
                  (url) {
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Image.asset(
                      url,
                      fit: BoxFit.cover,
                      // width: 1600.0
                    ),
                  ),
                );
              },
            ).toList(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
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
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index != currentIndex ? 30 : 60,
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
          SizedBox(height: 32),
          for (var i = 0; i < des.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Container(
                        child: Text(des[i],style: GoogleFonts.roboto(),)),
                  )
                ],
              ),
            ),


          ],



        ],
      ),
    );
  }

}
