import 'dart:convert';

import 'package:pingolearn/models.dart';
import 'package:http/http.dart' as http;

class Repository {
  static const String apiKey = 'f515d5520af442b39eb8c72959752b17';

  Future<List<Model>?> getNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = <Model>[];

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      final status = body['status'];
      if (status == 'ok') {
        final articles = body['articles'] as List<dynamic>;
        for (final article in articles) {
          final model = Model.fromJson(json: article as Map<String, dynamic>);
          result.add(model);
        }

        return result;
      }
    }
    return null;
  }
}
