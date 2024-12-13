import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:stream_transform/stream_transform.dart';

import '../models/post.dart';
import '../services/posts_api.dart';

part 'post_event.dart';
part 'post_state.dart';

const Duration _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({PostApi? postApi})
      : _postApi = postApi ?? PostApi(),
        super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: _throttleDroppable(_throttleDuration),
    );
  }
  final PostApi _postApi;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    /// Do nothing if reached the end of posts.
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final List<Post> posts = await _postApi.fetchPosts(0);
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      final List<Post> posts = await _postApi.fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: PostStatus.success,
              posts: [...state.posts, ...posts],
              hasReachedMax: false,
            ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
