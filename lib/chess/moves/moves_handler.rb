module Chess
  module MovesHandler
    include EnPassent
    include Promotion
    include Castling

    def handle_moves(position, destination)
      piece = at(position)
      color = piece.color

      return handle_castling(position, destination) if piece.king? && castling_move?(color, position, destination)

      capture_enpassent(position, destination) if piece.pawn? && enpassent_square?(destination)
      fen.update(position, destination, self)
      move_piece(position, destination)
      promote(destination, color)
      fen.update_states(placement_string)
    end

    def move_piece(piece_position, destination)
      change_value(destination, at(piece_position))
      change_value(piece_position, nil)
    end

    def reset_move(piece_position, destination, destination_value)
      change_value(piece_position, at(destination))
      change_value(destination, destination_value)
      reset_enpassent_move(at(piece_position), destination)
    end

    def reset_enpassent_move(piece, destination)
      return unless enpassent_square?(destination) && piece.pawn?

      color = opponent_color(piece.color)
      position = enpassent_position(destination, piece.color)
      change_value(position, Pawn.new(color))
    end

    def capture_enpassent(piece_position, destination)
      return unless at(piece_position).pawn?

      enpassent_piece_position = enpassent_to_capture(piece_position, destination, self)
      return unless enpassent_square?(destination)

      change_value(enpassent_piece_position, nil)
    end

    def handle_castling(position, destination)
      fen.update(position, destination, self)
      castling(position, destination)
      fen.update_states(placement_string)
    end

    def promote(position, color)
      return unless promotable?(position, color)

      display
      selected_promotion = Chess.select_from_menu(promotions(color), CLI.promotion_option_msg)
      change_value(position, selected_promotion)
      puts "Pawn promoted to #{at(position).name.capitalize}."
    end
  end
end
