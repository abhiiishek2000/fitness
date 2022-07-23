class Subscription{
  String imgPath;
  String type;
  String price;


  Subscription({required this.imgPath,required this.price,required this.type});
}


List<Subscription> subsList =[
  Subscription(
      imgPath: "assets/images/banner_1.jpg", price: "1299", type: "Weekly"),
  Subscription(
      imgPath: "assets/images/banner_2.jpg", price: "1899", type: "Monthly"),
  Subscription(
      imgPath: "assets/images/banner-3.jpg", price: "2999", type: "Yearly"),

];