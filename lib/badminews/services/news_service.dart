import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/news.dart';

class NewsService {
  // static const String baseUrl = 'http://127.0.0.1:8000'; // localhost for web development
  
  static const String baseUrl = 'http://localhost:8000/';

  Future<List<News>> getNews(CookieRequest request, {
    String? category,
    String? search,
    String? sort,
  }) async {
    final queryParams = <String, String>{};
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;

    final uri = Uri.parse('$baseUrl/badminews/json/').replace(queryParameters: queryParams);
    final response = await request.get(uri.toString());

    if (response != null) {
      final List<dynamic> data = response;
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> getTrendingNews(CookieRequest request) async {
    final response = await request.get('$baseUrl/badminews/trending/');

    if (response != null) {
      final List<dynamic> data = response;
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending news');
    }
  }

  Future<News> getNewsDetail(CookieRequest request, int id) async {
    final response = await request.get('$baseUrl/badminews/$id/?format=json');

    if (response != null) {
      return News.fromJson(response);
    } else {
      throw Exception('Failed to load news detail');
    }
  }

  Future<Map<String, dynamic>> upvoteNews(CookieRequest request, int newsId) async {
    final response = await request.post('$baseUrl/badminews/$newsId/upvote/', {});

    if (response != null) {
      return response;
    } else {
      throw Exception('Failed to upvote');
    }
  }

  Future<News> createNews(CookieRequest request, {
    required String title,
    required String content,
    required String category,
    String? imagePath,
  }) async {
    final response = await request.post('$baseUrl/badminews/create-ajax/', {
      'title': title,
      'content': content,
      'category': category,
    });

    if (response != null && response['success'] == true) {
      return News.fromJson(response['news_data']);
    } else {
      throw Exception(response?['message'] ?? 'Failed to create news');
    }
  }

  Future<News> updateNews(CookieRequest request, int newsId, {
    required String title,
    required String content,
    required String category,
  }) async {
    final response = await request.post('$baseUrl/badminews/$newsId/edit/', {
      'title': title,
      'content': content,
      'category': category,
    });

    if (response != null && response['success'] == true) {
      return News.fromJson(response['news_data']);
    } else {
      throw Exception(response?['message'] ?? 'Failed to update news');
    }
  }

  Future<bool> deleteNews(CookieRequest request, int newsId) async {
    final response = await request.post('$baseUrl/badminews/$newsId/delete/', {});

    if (response != null) {
      return true;
    } else {
      throw Exception('Failed to delete news');
    }
  }
}