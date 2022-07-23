import 'package:flutter/cupertino.dart';

class Category {
  final String image;
  final Color color;
  final String title;

  Category({
    required this.title,
    required this.color,
    required this.image,

  });
}

List<Category> Categorys = [
  Category(
    title: 'GYM',
    image: 'workout.png',
    color: Color(0xff625986),

  ),
  Category(
    title: 'YOGA',
    image: 'gym.png',
    color: Color(0xffff8fab),

  ), Category(
    title: 'SPA',
    image: 'workout.png',
    color: Color(0xff92b7fe),

  ),
  Category(
    title: 'Zumba/Dance',
    image: 'zumba.png',
    color: Color(0xff625986),

  ),
  Category(
    title: 'Crossfit',
    image: 'weightlifting.png',
    color: Color(0xffff8fab),

  ), Category(
    title: 'Physiotherapy',
    image: 'physical-therapy.png',
    color: Color(0xff92b7fe),

  ),
  Category(
    title: 'Sports Center',
    image: 'dumbbell.png',
    color: Color(0xff92b7fe),

  ),

];



