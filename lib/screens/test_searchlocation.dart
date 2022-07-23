import 'package:flutter/material.dart';

import 'HomePage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_result ?? '', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () async {
                var result = await showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                setState(() => _result = result);
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String> {
  List<String> cityname = ["patna","delhi","pammmm","dec","vv"];
  List<String> cityid=["1","2","3","4","5"];

  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = cityname.where((e) => e.contains(query) && e.startsWith(query)).toList();
    else
      listToShow = cityname;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i];
        return ListTile(
          title: Text(noun),
          onTap: () {
            int index=cityname.indexOf(noun.toString());
            print(noun+cityid[index]);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomePage(cityname: noun,cityid: cityid[index]),
            //   ),
            // );
            close(context, noun);
          },
        );
      },
    );
  }
}