enum ChaturangPieceType { pawn, rook, horse, elephant, queen, king }

class ChaturangPiece {
  final ChaturangPieceType type;
  final bool isWhite;
  final String imagePath;

  ChaturangPiece({
    required this.type,
    required this.isWhite,
    required this.imagePath,
  });
}
