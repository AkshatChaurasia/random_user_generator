import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List userData;
  bool isLoading = true;
  final String url = "https://randomuser.me/api/?results=50";

  Future getData() async {
    var response = await http
        .get(Uri.parse(url), headers: {"Aceept": "applications/json"});
    List data = jsonDecode(response.body)['results'];
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Users"),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: getData,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: Image(
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  userData[index]['picture']['thumbnail'],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userData[index]['name']['first'] +
                                        " " +
                                        userData[index]['name']['last'],
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "☎️: ${userData[index]['phone']}",
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                  Text(
                                    "⚥ : ${userData[index]['gender']}",
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
