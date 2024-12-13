import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostApi {
  PostApi({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  final int _fetchLimit = 10;

  /// Fetch multiple [Post]s from [PostApi].
  Future<List<Post>> fetchPosts(int startIndex) async {
    final response = await _httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{
          '_start': startIndex.toString(),
          '_limit': _fetchLimit.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map<Post>((dynamic parsedJson) {
        final json = parsedJson as Map<String, dynamic>;
        return Post.fromJson(json);
      }).toList();
    }
    debugPrint('[PostApi] ErrorStatusCode: ${response.statusCode}');
    throw Exception('error fetching posts');
  }

  /// Fetch a single [Post] from [PostApi].
  Future<Post> fetchPost(int id) async {
    final response = await _httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts/$id',
      ),
    );
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      return Post.fromJson(parsedJson);
    }
    debugPrint('[PostApi] ErrorStatusCode: ${response.statusCode}');
    throw Exception('error fetching post');
  }
}
