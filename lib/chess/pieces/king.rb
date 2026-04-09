module Chess
  class King < Piece
    DIRECTIONS = [[:north_east], [:north], [:north_west], [:west], [:south_west],
                  [:south], [:south_east], [:east]].freeze

    def safe_moves(position, board)
      opponent_positions = board.opponent_positions(color)
      moves = (available_moves(position, board) + castling_moves(board, position)).reject(&:empty?)
      moves.reject do |move|
        destination_value = board.at(move)
        board.move_piece(position, move)
        check = board.king_in_check?(color, move, opponent_positions)
        board.reset_move(position, move, destination_value)
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
