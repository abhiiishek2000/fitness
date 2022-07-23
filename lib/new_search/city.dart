class City {
  final String id;
  final String cityname;
  final String urlImage;

  const City({
    required this.id,

    required this.cityname,
    required this.urlImage,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'],
        cityname: json['name'],
        urlImage: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': cityname,
        'urlImage': urlImage,
      };
}
