import 'package:flutter/cupertino.dart';

class Activities {
  final String image;
  final Color color;
  final String title;


  Activities({
    required this.title,
    required this.color,
    required this.image,

  });
}

List<Activities> ActivityList = [
  Activities(
    title: 'Calories Counter',
    image: 'calories.png',
    color: Color(0xff024581),

  ), Activities(
    title: 'Heart Rate',
    image: 'heart-attack.png',
    color: Color(0xffec4a4f),

  ), Activities(
    title: 'Daily Steps',
    image: 'steps.png',
    color: Color(0xff0eabb5),

  ),


];