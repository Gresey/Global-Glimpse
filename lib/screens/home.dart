import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsify/model/NewsModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<NewsModel> news = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    var response = await http.get(Uri.parse("https://newsapi.org/v2/everything?domains=wsj.com&apiKey=8b34cf3400924ae187fd63beaef3d768"));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<NewsModel> loadedNews = [];
      for (var article in jsonData['articles']) {
        loadedNews.add(NewsModel.fromJson(article));
      }
      setState(() {
        news = loadedNews;
      });
    } else {
      print('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsify"),
      ),
      body: news.isEmpty ? Center(child: Text("No news found or check your internet connection.")) :
      ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(news[index].title ?? "No Title"),
              subtitle: Text(news[index].description ?? "No Description"),
              leading: news[index].urlToImage != null ? Image.network(news[index].urlToImage!, width: 100, fit: BoxFit.cover) : null,
            ),
          );
        },
      ),
    );
  }
}
