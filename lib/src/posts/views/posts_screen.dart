import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../widgets/post_tile.dart';
import '../widgets/bottom_loader.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Discussion'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => PostBloc(),
        child: const PostsList(),
      ),
    );
  }
}

class PostsList extends StatefulWidget {
  const PostsList({
    super.key,
  });

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostFetched());
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      // buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator.adaptive());
          case PostStatus.failure:
            return const Center(child: CircularProgressIndicator.adaptive());
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return ListView.builder(
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              // itemExtent: , //forces children's given extent in the scroll direction.
              controller: _scrollController,
              itemBuilder: (context, index) {
                return index >= state.posts.length
                    ? const BottomLoader()
                    : PostTile(post: state.posts[index]);
              },
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
