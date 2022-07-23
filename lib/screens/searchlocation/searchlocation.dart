import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:flutter/material.dart';
import 'package:go_fit_now/screens/searchlocation/players.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:http/http.dart' as http;

import '../HomePage.dart';

class searchlocation extends StatefulWidget {
  @override
  _searchlocationState createState() => _searchlocationState();
}

class _searchlocationState extends State<searchlocation> {


  List itemid = [];
  late List data;
  List imagesUrl = [];
  List itemname = [];

  List<Map> rows=[];
  String query = '';
  late TextEditingController tc;

  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();

  late AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    tc = TextEditingController();
    _loadData();
    fetchDataFromApi();
  }



  Future<String> fetchDataFromApi() async {
    var jsonData = await http.get("https://biographydad.com/api/city");
    var fetchData = jsonDecode(jsonData.body);
    setState(() {
      data = fetchData['Data'];
      data.forEach((element) {
        imagesUrl.add(element['image']);
        itemname.add(element['name']);
        itemid.add(element['id']);
      });
    });
    return "Success";
  }


  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
        appBar: appbarwidget(),
        body: Column(
          children: [

            new Center(
                child: new Column(children: <Widget>[
                  new Column(children: <Widget>[
                    searchTextField = AutoCompleteTextField<Players>(
                        style: new TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: new InputDecoration(
                            suffixIcon: Container(
                              width: 85.0,
                              height: 60.0,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                            filled: true,
                            hintText: 'Enter the Location',
                            hintStyle: TextStyle(color: Colors.black)),
                        itemSubmitted: (item) {
                          print(item.autocompleteterm);
                          setState(() => searchTextField.textField.controller?.text =
                              item.autocompleteterm);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(cityname: item.autocompleteterm,cityid: item.id),
                            ),
                          );
                        },
                        clearOnSubmit: false,
                        key: key,
                        suggestions: PlayersViewModel.players,
                        itemBuilder: (context, item) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        item.imageurl),
                                    // fit: BoxFit.fill
                                  ),
                                ),
                              ),
                              // NetworkImage()
                              Text(item.autocompleteterm,
                                style: TextStyle(
                                    fontSize: 16.0
                                ),),
                              Padding(
                                padding: EdgeInsets.all(15.0),
                              ),

                            ],
                          );
                        },
                        itemSorter: (a, b) {
                          return a.autocompleteterm.compareTo(b.autocompleteterm);
                        },
                        itemFilter: (item, query) {
                          return item.autocompleteterm
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        }),
                  ]),
                ]))
          ],
        ));
  }
}

void _loadData() async{
  await PlayersViewModel.loadPlayers();
}