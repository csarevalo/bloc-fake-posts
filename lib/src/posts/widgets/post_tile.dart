import 'package:bloc_posts/src/posts/models/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: ListTile(
        leading: Text(post.id.toString()),
        // isThreeLine: true,
        title: Text(post.title),
        subtitle: Text(post.body),
      ),
    );
  }
}
