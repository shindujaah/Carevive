import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';
import 'source_model.dart';

class NewsService {
  final String apiKey = '1136bff5f82e4140b21e7bf3912da168'; // Replace with your NewsAPI key
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<News>> fetchNewsByCategory(String category, {int page = 1, String sortBy = 'publishedAt'}) async {
    final url = '$baseUrl/top-headlines?category=$category&language=en&apiKey=$apiKey&page=$page&pageSize=10&sortBy=$sortBy';
    print('Fetching news by category: $category, page: $page, sortBy: $sortBy');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['articles'];
      return data.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> fetchNewsByKeyword(String keyword, {int page = 1, String sortBy = 'publishedAt'}) async {
    final url = '$baseUrl/everything?q=$keyword&language=en&apiKey=$apiKey&page=$page&pageSize=10&sortBy=$sortBy';
    print('Fetching news by keyword: $keyword, page: $page, sortBy: $sortBy');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['articles'];
      return data.where((article) => article['title'] != '[Removed]').map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<Source>> fetchNewsSources({String? category, String? language}) async {
    final url = '$baseUrl/top-headlines/sources?apiKey=$apiKey'
        '${category != null ? '&category=$category' : ''}'
        '${language != null ? '&language=$language' : ''}';
    print('Fetching news sources: category: $category, language: $language');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['sources'];
      return data.map((source) => Source.fromJson(source)).toList();
    } else {
      throw Exception('Failed to load news sources');
    }
  }
}

