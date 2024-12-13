import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      margin: const EdgeInsets.all(24.0),
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
