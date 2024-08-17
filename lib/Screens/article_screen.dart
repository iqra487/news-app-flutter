import 'package:flutter/material.dart';
import 'package:news_app/models/articles.dart';
import 'package:news_app/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleDetailsPage extends StatelessWidget {
  final Articles article;

  const ArticleDetailsPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title ?? 'Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                fit: BoxFit.cover,
                width: width * 0.8,
                height: height * 0.3,
              ),
            const SizedBox(height: 16.0),
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              article.source?.name ?? 'Unknown Source',
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              timeago.format(DateTime.parse(article.publishedAt!)),
              style: const TextStyle(
                  fontSize: 16.0,
                  color: colorOrange,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              article.content ?? 'No Content Available',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
