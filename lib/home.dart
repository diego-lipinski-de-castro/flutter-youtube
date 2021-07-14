import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];
  bool error = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    getPosts();
  }

  void getPosts() async {
    setState(() {
      loading = true;
    });

    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      posts = List.from(data).map((post) => Post.fromJson(post)).toList();

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  void getPost(int id) async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');

    http.Response response = await http.get(url);

    var data = jsonDecode(response.body);

    Post post = Post.fromJson(data);

    print(post);
    print(post.id);
    print(post.title);
  }

  void createPost() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    http.Response response = await http.post(
      url,
      body: {
        'title': 'foo',
        'body': 'bar',
        'userId': '1',
      },
    );

    print(response.statusCode);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  if (error) ...[
                    Text('Houve um problema'),
                  ],
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];

                      return ListTile(
                        onTap: () {
                          getPost(post.id);
                        },
                        title: Text(post.title),
                      );
                    },
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createPost,
        child: Icon(Icons.add),
      ),
    );
  }
}
