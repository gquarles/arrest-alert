import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrest Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Arrest Alert'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUsers() async {
    var data = await http.get("http://server.gquarles.com/arrests.json");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for(var u in jsonData) {
      User user = User(u["name"], u["charges"], u["time"], u["picture"]);
      users.add(user);
    }

    return users;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading...")
                )
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data[index].picture
                    ),
                  ),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].time),
                  onTap: () {
                    Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                    );
                  },
                );
              },
            );
          },
        ),
      )
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0)
              ),
              Container(
                height: 200.0,
                width: 270.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(user.picture)
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0)
              ),
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  Container(
                    child: ListTile(
                      title: Text(user.name),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text(user.time),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text(user.charges),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String charges;
  final String time;
  final String picture;

  User(this.name, this.charges, this.time, this.picture);

}