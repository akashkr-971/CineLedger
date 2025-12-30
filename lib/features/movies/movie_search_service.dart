import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieSearchService {
  static const _baseUrl = 'https://api.themoviedb.org/3';

  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<Map<String, dynamic>?> searchMovie({
    required String title,
    int? year,
  }) async {
    print("CALLED");
    print(_apiKey);
    final uri = Uri.parse('$_baseUrl/search/movie').replace(
      queryParameters: {
        'query': title,
        'api_key': _apiKey,
        if (year != null) 'year': year.toString(),
      },
    );

    print(uri);

    final response = await http.get(uri);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch movie data');
    }

    final data = json.decode(response.body);
    print(data);

    final results = data['results'] as List;

    if (results.isEmpty) return null;

    return results.first as Map<String, dynamic>;
  }
}
