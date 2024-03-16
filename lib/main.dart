import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flirting/models/article_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ArticleModel? articleModel;

  Future<void> _loadArticle() async {
    var res = await rootBundle.loadString('assets/article.json');
    var json = await jsonDecode(res);
    articleModel = ArticleModel.fromJson(json['article']);
    setState(() {});
  }

  Future<void> _exportArticle() async {
    var json = articleModel?.toJson();
    var res = jsonEncode(json);
    debugPrint(res);
    setState(() {
      articleModel = null;
    });
  }

  void _changeAuthor() {
    articleModel = articleModel?.copyWith(
      author: articleModel?.author?.copyWith(
        username: 'Woong',
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modeling example'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _loadArticle,
                    child: const Text('불러오기'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _exportArticle,
                    child: const Text('내보내기'),
                  ),
                ],
              ),
              if (articleModel != null)
                Column(
                  children: [
                    Text(articleModel?.slug ?? ''),
                    Text(articleModel?.title ?? ''),
                    Text(articleModel?.description ?? ''),
                    Text(articleModel?.body ?? ''),
                    Text(articleModel?.tagList.toString() ?? ''),
                    Text(articleModel?.createdAt.toString() ?? ''),
                    Text(articleModel?.updatedAt.toString() ?? ''),
                    Text(articleModel?.favorited.toString() ?? ''),
                    Text(articleModel?.favoritesCount.toString() ?? ''),
                    const SizedBox(height: 20),
                    if (articleModel?.author != null)
                      Column(
                        children: [
                          Text(articleModel?.author?.username ?? ''),
                          Text(articleModel?.author?.bio ?? ''),
                          Text(articleModel?.author?.image ?? ''),
                          Text(
                              articleModel?.author?.following.toString() ?? ''),
                        ],
                      ),
                  ],
                ),
              if (articleModel != null)
                ElevatedButton(
                  onPressed: _changeAuthor,
                  child: const Text('작성자 이름 바꾸기'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
