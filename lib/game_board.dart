import 'package:chaturang/Components/square.dart';
import 'package:chaturang/helper/helper_method.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8 * 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            // return Square(isWhite: isWhite(index));
          }),
    );
  }
}
