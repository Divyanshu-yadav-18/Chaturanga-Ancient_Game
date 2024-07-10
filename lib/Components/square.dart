import 'package:chaturang/Components/piece.dart';
import 'package:chaturang/Values/color.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChaturangPiece? piece;
  const Square({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? foreGroundColor : backGroundColor,
      child: piece != null
          ? Image.asset(
              piece!.imagePath,
              color: piece!.isWhite ? Colors.white : Colors.black,
            )
          : null,
    );
  }
}
