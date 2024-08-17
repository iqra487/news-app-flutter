import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/articles.dart';

class NewsService {
  final String apiKey = '1682f16184d941268c42a0aca9fd7749';
  final String apiUrl = 'https://newsapi.org/v2/everything?q=bitcoin';

  Future<List<Articles>> fetchArticles() async {
    final response = await http.get(Uri.parse('$apiUrl&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['articles'];
      return jsonData.map((json) => Articles.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
