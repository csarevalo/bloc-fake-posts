import 'package:bloc_posts/src/posts/views/posts_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Posts',
      theme: ThemeData.dark(),
      home: const PostsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
