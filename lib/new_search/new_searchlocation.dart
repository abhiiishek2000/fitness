import 'dart:async';
import 'dart:convert';
import 'package:go_fit_now/home/spa_page.dart';
import 'package:go_fit_now/home/yoga_page.dart';
import 'package:go_fit_now/screens/HomePage.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_fit_now/new_search/city.dart';
import 'package:go_fit_now/new_search/search_widget.dart';

import '../home/gym_page.dart';

class newcitysearch extends StatefulWidget {
  newcitysearch({required this.isFromGYM,required this.isFromSapa,required this.isFromYoga});
final bool isFromYoga;
final bool isFromSapa;
final bool isFromGYM;

  @override
  newcitysearchState createState() => newcitysearchState();

}

class newcitysearchState extends State<newcitysearch> {
  List<City> cities = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    fetchdata();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future fetchdata() async {
    final books = await CityApi.getCities(query);

    setState(() => this.cities = books);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appbarwidget(),
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final book = cities[index];
              return buildBook(book);
            },
          ),
        ),
      ],
    ),
  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search City',
    onChanged: searchCity,
  );

  Future searchCity(String query) async => debounce(() async {
    final city = await CityApi.getCities(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.cities = city;
    });
  });

  Widget buildBook(City City) => ListTile(
    onTap: (){
      if(widget.isFromYoga){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => YogaScreen(cityname: City.cityname,cityid: City.id)),
              (Route<dynamic> route) => false,
        );
      }
      if(widget.isFromGYM){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => GymPage(cityname: City.cityname,cityid: City.id)),
              (Route<dynamic> route) => false,
        );
      }
      if(widget.isFromSapa){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SpaScreen(cityname: City.cityname,cityid: City.id)),
              (Route<dynamic> route) => false,
        );
      }

    },
    leading: Image.network(
      City.urlImage,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(City.cityname),

  );
}



class CityApi {
  static Future<List<City>> getCities(String query) async {
    final url = Uri.parse(
        'https://biographydad.com/api/city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // final List books = json.decode(response.body);
      var fetchData = json.decode(response.body);
      List data = fetchData['Data'] as List;

      return data.map((json) => City.fromJson(json)).where((city) {
        final titleLower = city.cityname.toLowerCase();
        // final authorLower = book.author.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ;
      }).toList();
    } else {
      throw Exception();
    }
  }
}























// import 'package:flutter/material.dart';
//
// import 'HomePage.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   String? _result;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search')),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Text(_result ?? '', style: TextStyle(fontSize: 18)),
//             ElevatedButton(
//               onPressed: () async {
//                 var result = await showSearch<String>(
//                   context: context,
//                   delegate: CustomDelegate(),
//                 );
//                 setState(() => _result = result);
//               },
//               child: Text('Search'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomDelegate extends SearchDelegate<String> {
//   List<String> cityname = ["patna","delhi","pammmm","dec","vv"];
//   List<String> cityid=["1","2","3","4","5"];
//
//   @override
//   List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
//
//   @override
//   Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));
//
//   @override
//   Widget buildResults(BuildContext context) => Container();
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     var listToShow;
//     if (query.isNotEmpty)
//       listToShow = cityname.where((e) => e.contains(query) && e.startsWith(query)).toList();
//     else
//       listToShow = cityname;
//
//     return ListView.builder(
//       itemCount: listToShow.length,
//       itemBuilder: (_, i) {
//         var noun = listToShow[i];
//         return ListTile(
//           title: Text(noun),
//           onTap: () {
//             int index=cityname.indexOf(noun.toString());
//             print(noun+cityid[index]);
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => HomePage(cityname: noun,cityid: cityid[index]),
//             //   ),
//             // );
//             close(context, noun);
//           },
//         );
//       },
//     );
//   }
// }