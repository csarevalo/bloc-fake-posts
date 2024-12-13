import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/posts/bloc/post_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const PostBlocObserver();
  runApp(const App());
}
