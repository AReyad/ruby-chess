module Chess
  module MovesHandler
    include EnPassent
    include Promotion
    include Castling

    def handle_moves(position, destination)
      piece = at(position)
      color = piece.color

      return castling(color, position, destination) if piece.king? && castling_move?(color, position, destination)

      capture_enpassent(position, destination) if piece.pawn? && enpassent_square?(destination)

      move_piece(position, destination)
    end
  end
end
