module Chess
  class King < Piece
    DIRECTIONS = [[:north_east], [:north], [:north_west], [:west], [:south_west],
                  [:south], [:south_east], [:east]].freeze

    def safe_moves(position, board)
      board_clone = board.clone
      opponent_positions = board_clone.opponent_positions(color)
      moves = (available_moves(position, board) + castling_moves(board, position)).reject(&:empty?)
      moves.reject do |move|
        destination_value = board_clone.at(move)
        board_clone.move_piece(position, move)
        check = board_clone.king_in_check?(color, move, opponent_positions)
        board_clone.reset_move(position, move, destination_value)
        check
      end
    end

    def castling_moves(board, position)
      default_position = board.default_king_position(color)
      return [] unless position == default_position
      return [] unless board.castlable?(color, board, default_position)
      return [] if board.king_in_check?(color, position)

      board.castling_moves(color, board, default_position)
    end
  end
end
