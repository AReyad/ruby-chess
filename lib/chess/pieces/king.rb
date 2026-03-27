module Chess
  class King < Piece
    DIRECTIONS = [[:north_east], [:north], [:north_west], [:west], [:south_west],
                  [:south], [:south_east], [:east]].freeze

    def safe_moves(position, board)
      board_clone = board.clone
      current_position = position
      opponent_positions = board_clone.opponent_positions(color)
      moves = (available_moves(position, board) + castling_moves(board, position)).reject(&:empty?)
      moves.reject do |move|
        board_clone.move_piece(current_position, move)
        current_position = move
        board_clone.king_in_check?(color, current_position, opponent_positions)
      end
    end

    def castling_moves(board, position)
      default_position = board.default_king_position(color)
      return [] unless position == default_position
      return [] unless board.castlable?(color, board, default_position)

      return board.white_castling_moves(color, board, default_position) if white?

      board.black_castling_moves(color, board, default_position)
    end
  end
end
