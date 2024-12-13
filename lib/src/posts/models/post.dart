import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  @override
  List<Object> get props => [id, title, body];

  Post.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] as int,
        title = parsedJson['title'] as String,
        body = parsedJson['body'] as String;
}
