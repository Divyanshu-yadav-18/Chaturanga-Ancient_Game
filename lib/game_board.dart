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

  //the currently selected piece on board
  ChaturangPiece? selectedPiece;

  //row index of selected piece

  int selectedRow = -1;

  //col index of selected piece

  int selectedCol = -1;

  //list valid move of selected piece
  //each move is represented as list of row and col

  List<List<int>> validMoves = [];

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
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChaturangPiece(
        type: ChaturangPieceType.pawn,
        isWhite: false,
        imagePath: 'lib/images/b_pawn.png',
      );

      newBoard[6][i] = ChaturangPiece(
        type: ChaturangPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/images/b_pawn.png',
      );
    }

    //rook
    newBoard[0][0] = ChaturangPiece(
        type: ChaturangPieceType.rook,
        isWhite: false,
        imagePath: 'lib/images/b_rook.png');

    newBoard[0][7] = ChaturangPiece(
        type: ChaturangPieceType.rook,
        isWhite: false,
        imagePath: 'lib/images/b_rook.png');

    newBoard[7][0] = ChaturangPiece(
        type: ChaturangPieceType.rook,
        isWhite: true,
        imagePath: 'lib/images/b_rook.png');

    newBoard[7][7] = ChaturangPiece(
        type: ChaturangPieceType.rook,
        isWhite: true,
        imagePath: 'lib/images/b_rook.png');

    //horses
    newBoard[0][1] = ChaturangPiece(
        type: ChaturangPieceType.horse,
        isWhite: false,
        imagePath: 'lib/images/b_horse.png');

    newBoard[0][6] = ChaturangPiece(
        type: ChaturangPieceType.horse,
        isWhite: false,
        imagePath: 'lib/images/b_horse.png');

    newBoard[7][1] = ChaturangPiece(
        type: ChaturangPieceType.horse,
        isWhite: true,
        imagePath: 'lib/images/b_horse.png');

    newBoard[7][6] = ChaturangPiece(
        type: ChaturangPieceType.horse,
        isWhite: true,
        imagePath: 'lib/images/b_horse.png');

    //elephant

    newBoard[0][2] = ChaturangPiece(
        type: ChaturangPieceType.elephant,
        isWhite: false,
        imagePath: 'lib/images/b_elephant.png');

    newBoard[0][5] = ChaturangPiece(
        type: ChaturangPieceType.elephant,
        isWhite: false,
        imagePath: 'lib/images/b_elephant.png');

    newBoard[7][2] = ChaturangPiece(
        type: ChaturangPieceType.elephant,
        isWhite: true,
        imagePath: 'lib/images/b_elephant.png');

    newBoard[7][5] = ChaturangPiece(
        type: ChaturangPieceType.elephant,
        isWhite: true,
        imagePath: 'lib/images/b_elephant.png');
    //queen

    newBoard[0][4] = ChaturangPiece(
        type: ChaturangPieceType.queen,
        isWhite: false,
        imagePath: 'lib/images/b_queen.png');

    newBoard[7][3] = ChaturangPiece(
        type: ChaturangPieceType.queen,
        isWhite: true,
        imagePath: 'lib/images/b_queen.png');
    //king

    newBoard[0][3] = ChaturangPiece(
        type: ChaturangPieceType.king,
        isWhite: false,
        imagePath: 'lib/images/b_king.png');

    newBoard[7][4] = ChaturangPiece(
        type: ChaturangPieceType.king,
        isWhite: true,
        imagePath: 'lib/images/b_king.png');

    board = newBoard;
  }

  void pieceSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      // if a piece is selected, calculate its valid move
      validMoves =
          calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  //calculate raw valid moves
  List<List<int>> calculateRawValidMoves(
      int row, int col, ChaturangPiece? piece) {
    List<List<int>> candidateMoves = [];
  }

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
            //get the row and column for this square
            int row = index ~/ 8;
            int col = index % 8;

            bool isSelected = selectedRow == row && selectedCol == col;

            return Square(
              isWhite: isWhite(index),
              piece: board[row][col],
              isSelected: isSelected,
              onTap: () => pieceSelected(row, col),
            );
          }),
    );
  }
}
