import 'package:chaturang/Components/dead_piece.dart';
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

  //list of white piece taken

  List<ChaturangPiece> whitePiceTaken = [];

  //list of black piece taken

  List<ChaturangPiece> blackPieceTaken = [];

  //switch players turn
  bool isWhiteTurn = true;

  //track of kings position

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  bool checkStatus = false;

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

    newBoard[0][3] = ChaturangPiece(
        type: ChaturangPieceType.queen,
        isWhite: false,
        imagePath: 'lib/images/b_queen.png');

    newBoard[7][3] = ChaturangPiece(
        type: ChaturangPieceType.queen,
        isWhite: true,
        imagePath: 'lib/images/b_queen.png');
    //king

    newBoard[0][4] = ChaturangPiece(
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
      //no piece is selected, its the first selestion
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      //there's a piece already selectedboard
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      // if a piece is selected, calculate its valid move
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //calculate raw valid moves
  List<List<int>> calculateRawValidMoves(
      int row, int col, ChaturangPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    //different direction based on their color
    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChaturangPieceType.pawn:
        //pawn move one step ahead if square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //pawn move two step at start
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              (board[row + 2 * direction][col] == null) &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        //pawn can kill diagonally

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChaturangPieceType.rook:
        var direction = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ];

        for (var direct in direction) {
          var i = 1;
          while (true) {
            var newRow = row + i * direct[0];
            var newCol = col + i * direct[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChaturangPieceType.horse:
        var horseMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ];

        for (var move in horseMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChaturangPieceType.elephant:
        var elephantMoves = [
          [-2, -2],
          [-2, 2],
          [2, -2],
          [2, 2],
        ];

        for (var move in elephantMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChaturangPieceType.queen:
        var queenMoves = [
          [1, 1],
          [-1, 1],
          [1, -1],
          [-1, -1]
        ];

        for (var moves in queenMoves) {
          var newRow = row + moves[0];
          var newCol = col + moves[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChaturangPieceType.king:
        var kingMoves = [
          [1, 0],
          [0, 1],
          [-1, 0],
          [0, -1],
          [1, 1],
          [-1, 1],
          [1, -1],
          [-1, -1]
        ];

        for (var moves in kingMoves) {
          var newRow = row + moves[0];
          var newCol = col + moves[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    return candidateMoves;
  }

  //Calculate real valid move
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChaturangPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    //after generating all candidate moves,filter out any that would result in check
    if (checkSimulation) {
      for (var moves in candidateMoves) {
        int endRow = moves[0];
        int endCol = moves[1];

        //simulate future move if its safe
        if (simulateMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(moves);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  //Move piece
  void movePiece(int newRow, int newCol) {
    //if the spot have enemy piece
    if (board[newRow][newCol] != null) {
      //add captured piece to the list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiceTaken.add(capturedPiece);
      } else {
        blackPieceTaken.add(capturedPiece);
      }
    }

    //if moved piece is king
    if (selectedPiece!.type == ChaturangPieceType.king) {
      //update the appropriate king pos
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    //move the piece and clear the old positions
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedCol = -1;
      selectedRow = -1;
      validMoves = [];
    });

    //switch turn
    isWhiteTurn = !isWhiteTurn;
  }

  //Is King In Check
  bool isKingInCheck(bool isWhiteKing) {
    //get the position of king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    //check if any enemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip null square and same color pieces
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //check kings position if in valid move
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  //simulate the future move to see if its safe
  bool simulateMoveIsSafe(ChaturangPiece piece, int startRow, int startCol,
      int endRow, int endCol) {
    //save current status
    ChaturangPiece? originalDestinationPiece = board[endRow][endCol];

    //if the piece is king save its position and update
    List<int>? originalKingPosition;
    if (piece.type == ChaturangPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update kings position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    //simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //check if our king is under attck
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restore board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    //if piece was king restore its original position
    if (piece.type == ChaturangPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    //if check -> king not safe
    return !kingInCheck;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          //white pieces taken
          Expanded(
            child: GridView.builder(
              itemCount: whitePiceTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiceTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          //Check Status

          Text(checkStatus ? "Check" : ""),

          Expanded(
            flex: 3,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8 * 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  //get the row and column for this square
                  int row = index ~/ 8;
                  int col = index % 8;

                  bool isSelected = selectedRow == row && selectedCol == col;

                  //check isValidMove

                  bool isValidMove = false;

                  for (var position in validMoves) {
                    if (position[0] == row && position[1] == col) {
                      isValidMove = true;
                    }
                  }

                  return Square(
                    isWhite: isWhite(index),
                    piece: board[row][col],
                    isSelected: isSelected,
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(row, col),
                  );
                }),
          ),

          //black pieces taken

          Expanded(
            child: GridView.builder(
              itemCount: blackPieceTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPieceTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
