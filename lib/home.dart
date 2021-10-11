import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practisapp/model/photos.dart';
import 'package:practisapp/model/todo.dart';
import 'package:practisapp/model/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Uri Url1 = Uri.parse("https://jsonplaceholder.typicode.com/users");
Uri Url2 = Uri.parse("https://jsonplaceholder.typicode.com/todos");
Uri Url3 = Uri.parse("https://jsonplaceholder.typicode.com/photos");

class _HomeState extends State<Home> {
  Future<List<dynamic>> fetchData() async {
    var responses =
        await Future.wait([http.get(Url1), http.get(Url2), http.get(Url3)]);

    return <dynamic>[
      userFromJson(responses[0].body),
      todoFromJson(responses[1].body),
      photosFromJson(responses[2].body)
    ];
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiple request"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
                future: fetchData(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    List<User> user = snap.data![0];
                    List<Todo> todo = snap.data![1];
                    List<Photos> photos = snap.data![2];
                    return Column(
                      children: [
                        Text(
                          "1",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                              itemCount: user.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    title: Text(user[index].name),
                                    subtitle: Text(user[index].email),
                                    leading: CircleAvatar(
                                      child: Text(
                                        user[index].id.toString(),
                                      ),
                                    ));
                              }),
                        ),
                        Divider(
                          color: Colors.red,
                        ),
                        Text(
                          "2",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 120,
                          child: ListView.builder(
                              itemCount: todo.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(todo[index].title),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Text(todo[index].id.toString()),
                                  ),
                                );
                              }),
                        ),
                        Divider(
                          color: Colors.red,
                        ),
                        Text(
                          "3",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.all(5),
                                    height: 90,
                                    child: CachedNetworkImage(
                                      imageUrl: photos[index].url,
                                    ));
                              }),
                        )
                      ],
                    );
                  } else if (snap.hasError) {
                    return Text("Error");
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}
