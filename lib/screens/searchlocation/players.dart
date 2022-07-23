import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Players {
  String keyword;
  String id;
  String autocompleteterm;
  String imageurl;

  Players({
     required this.keyword,
     required this.id,
     required this.autocompleteterm,
     required this.imageurl
  });

  factory Players.fromJson(Map<String, dynamic> parsedJson) {
    return Players(
        keyword: parsedJson['name'] as String,
        id: parsedJson['id'],
        autocompleteterm: parsedJson['name'] as String,
        imageurl: parsedJson['image'] as String
    );
  }
}

class PlayersViewModel {
  static List<Players> players=[];

  

  static Future loadPlayers() async {
    try {
      // ignore: deprecated_member_use
      players = <Players>[];
      var jsonData = await http.get("https://biographydad.com/api/city");
      var fetchData = json.decode(jsonData.body);
      List data = fetchData['Data'] as List;
      for (int i = 0; i < data.length; i++) {
        players.add(new Players.fromJson(data[i]));
        print(data);
      }
    } catch (e) {
      print(e);
    }
  }
}