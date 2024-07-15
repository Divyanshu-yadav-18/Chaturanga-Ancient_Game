import 'package:chaturang/Components/piece.dart';
import 'package:chaturang/Values/color.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChaturangPiece? piece;
  final bool isSelected;
  void Function()? onTap;
  final bool isValidMove;
  Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = Colors.amber;
    } else if (isValidMove) {
      squareColor = const Color.fromARGB(255, 251, 205, 67);
    } else {
      squareColor = isWhite ? foreGroundColor : backGroundColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
