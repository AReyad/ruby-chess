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

    def move_piece(piece_position, destination)
      change_value(destination, at(piece_position))
      change_value(piece_position, nil)
    end

    def capture_enpassent(piece_position, destination)
      return unless at(piece_position).pawn?

      enpassent_piece_position = enpassent_to_capture(piece_position, destination, self)
      return unless enpassent_square?(destination)

      change_value(enpassent_piece_position, nil)
    end
  end
end
