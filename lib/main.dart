import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Movie Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectMov = "";
  var desc = "";
  TextEditingController searchText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          const Text("Movie Title",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            controller: searchText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search Here',
            ),
            onChanged: (text) {
              setState(() {
                selectMov = text;
              });
            },
          ),
          ElevatedButton(onPressed: _click, child: const Text("Clik Here")),
          Text(desc,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      )),
    );
  }

  Future<void> _click() async {
    var apikey = "d38c8dab";
    var url = Uri.parse('https://www.omdbapi.com/?t=$selectMov&apikey=$apikey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200 && selectMov.isNotEmpty) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var title = parsedJson["Title"];
        var genre = parsedJson["Genre"];
        var year = parsedJson["Year"];
        var link = parsedJson["Poster"];

        desc =
            "Search result for $selectMov is $title \n\nThis movie genre is $genre and release in $year.\n\n $link";
      });
    } else {
      setState(() {
        desc = "No Record Found";
      });
    }
  }
}
