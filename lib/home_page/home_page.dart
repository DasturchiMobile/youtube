import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    apiGetDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dasturchi Mobile"),
      ),
      body: FutureBuilder(
        future: apiGetDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Xatolik ketti"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(12),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://yt3.googleusercontent.com/xS9BvUePguOIlNkp1dk-dDtUEmK2TI3RcP8AgCrF7AyFlHZn7pWJxOyL9_Je1jWb3OtcrNmaiA=s900-c-k-c0x00ffffff-no-rj"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.data?[index].title ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(snapshot.data?[index].body ?? ""),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Future<List<ApiModel>> apiGetDate() async {
    List<ApiModel> apiDate = [];
    try {
      final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      List<dynamic> date = json.decode(utf8.decode(response.bodyBytes));
      for (final item in date) {
        apiDate.add(
          ApiModel(
              id: item["id"],
              userId: item["userId"],
              title: item["title"],
              body: item["body"]),
        );
      }
    } catch (error) {
      print("catch run");
      print(error);
    }

    return apiDate;
  }
}

class ApiModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  ApiModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
}
