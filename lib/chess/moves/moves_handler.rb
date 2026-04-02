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
      fen.update(position, destination, self)
      move_piece(position, destination)
      promote(destination, color) if at(destination).pawn? && promotable?(destination, color)
    end

    def move_piece(piece_position, destination)
      change_value(destination, at(piece_position))
      change_value(piece_position, nil)
    end

    def reset_move(piece_position, destination, destination_value)
      change_value(piece_position, at(destination))
      change_value(destination, destination_value)
    end

    def capture_enpassent(piece_position, destination)
      return unless at(piece_position).pawn?

      enpassent_piece_position = enpassent_to_capture(piece_position, destination, self)
      return unless enpassent_square?(destination)

      change_value(enpassent_piece_position, nil)
    end

    def promote(position, color)
      display
      selected_promotion = select_promotion(promotions(color))
      change_value(position, selected_promotion)
      puts "Pawn promoted to #{at(position).name.capitalize}."
    end
  end
end
