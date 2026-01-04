import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieSearchService {
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<List<Map<String, dynamic>>> searchMovies({
    required String title,
    int? year,
  }) async {
    final uri = Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': _apiKey,
      'query': title,
      if (year != null) 'year': year.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch movie data');
    }

    final data = json.decode(response.body);
    final results = List<Map<String, dynamic>>.from(data['results']);
    return results;
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final uri = Uri.parse('https://api.themoviedb.org/3/movie/popular').replace(
      queryParameters: {'api_key': _apiKey, 'language': 'en-US', 'page': '1'},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch popular movies');
    }

    final data = json.decode(response.body);
    final results = List<Map<String, dynamic>>.from(data['results']);

    return results;
  }
}
