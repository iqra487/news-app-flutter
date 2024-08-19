import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:news_app/models/articles.dart';
import 'package:news_app/services/fetch_articles_services.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('NewsService', () {
    test(
        'fetchArticles returns a list of Articles if the http call completes successfully',
        () async {
      // Arrange
      final client = MockClient();
      final service = NewsService();

      // Mocking the response
      when(client.get(Uri.parse(
              'https://newsapi.org/v2/everything?q=bitcoin&apiKey=1682f16184d941268c42a0aca9fd7749')))
          .thenAnswer((_) async => http.Response(
              '{"articles":[{"title":"Test Article","source":{"name":"Test Source"},"urlToImage":"https://example.com/image.jpg","publishedAt":"2024-01-01T00:00:00Z"}]}',
              200));

      // Act
      final articles = await service.fetchArticles();

      // Assert
      expect(articles, isA<List<Articles>>());
      expect(articles.length, 1);
      expect(articles[0].title, 'Test Article');
      expect(articles[0].source!.name, 'Test Source');
    });

    test(
        'fetchArticles throws an exception if the http call completes with an error',
        () async {
      // Arrange
      final client = MockClient();
      final service = NewsService();

      // Mocking the response
      when(client.get(Uri.parse(
              'https://newsapi.org/v2/everything?q=bitcoin&apiKey=1682f16184d941268c42a0aca9fd7749')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() => service.fetchArticles(), throwsException);
    });
  });
}
