import 'dart:ffi';

import 'package:chaturang/Components/piece.dart';
import 'package:chaturang/Components/square.dart';
import 'package:chaturang/Values/color.dart';
import 'package:chaturang/helper/helper_method.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //A 2-D list represent the gameBoard,

  late List<List<ChaturangPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initializeboard();
  }

  //Initialize Board

  void _initializeboard() {
    //initialising the board with null, no piece present on board
    List<List<ChaturangPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //pawn

    //rook

    //horses

    //elephant

    //queen

    //king
  }

  ChaturangPiece myPawn = ChaturangPiece(
    type: ChaturangPieceType.pawn,
    isWhite: true,
    imagePath: 'lib/images/b_pawn.png',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8 * 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            return Square(
              isWhite: isWhite(index),
              piece: myPawn,
            );
          }),
    );
  }
}
