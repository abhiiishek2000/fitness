
import 'package:flutter/material.dart';
import 'package:go_fit_now/home/component/one_pass_live.dart';
import 'package:go_fit_now/home/component/personal_training.dart';
import 'package:google_fonts/google_fonts.dart';


class FitAtHome extends StatefulWidget {
  const FitAtHome({Key? key}) : super(key: key);

  @override
  _FitAtHomeState createState() => _FitAtHomeState();
}

class _FitAtHomeState extends State<FitAtHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Column(
        children: [
          InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalTrainingScreen())),
            child: Container(
              height: size.height*0.2,
              decoration: BoxDecoration(
                color: Color(0xfff8f5fe),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: Offset(0,6),
                  blurRadius: 9,
                )
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Personal Training',style: GoogleFonts.roboto(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400,),),
                        SizedBox(height: 8),
                        Text('Online one to one training',style: GoogleFonts.roboto(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w300,),),
                        SizedBox(height: 8),
                        Icon(Icons.arrow_circle_right,color: Colors.indigo,)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Align(
                           alignment: Alignment.bottomRight,
                            child: Image.asset('assets/images/gym1.jpeg',height: size.height*0.18,))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
         SizedBox(height: 16),
         Row(
           children: [
             Expanded(child: cardItems("OnePass LIVE","Interactive online group \nclasses","gym2.jpeg",()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>OnePassLiveScreen())))),
             SizedBox(width: 8),
             Expanded(child: cardItems("Fit TV","Digital workout by experts","gym3.jpeg",()=>null))
           ],
         )


        ],
      ),
    );
  }
  Widget cardItems(String title,String subtitle, String imgPath,Function() onPress){
    final size = MediaQuery.of(context).size;
    return  InkWell(
      onTap: onPress,
      child: Container(
        height: size.height*0.2,
        decoration: BoxDecoration(
            color: Color(0xfffff5e9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                offset: Offset(0,6),
                blurRadius: 9,
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(title,style: GoogleFonts.roboto(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400,),),
              SizedBox(height: 8),
              Text(subtitle,style: GoogleFonts.roboto(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w300,),),
              SizedBox(height: 8),
              Icon(Icons.arrow_circle_right,color: Colors.indigo,),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset('assets/images/$imgPath',height: size.height*0.15,)))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

