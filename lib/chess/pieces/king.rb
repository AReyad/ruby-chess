module Chess
  class King < Piece
    DIRECTIONS = [[:north_east], [:north], [:north_west], [:west], [:south_west],
                  [:south], [:south_east], [:east]].freeze

    def safe_moves(position, board)
      board_clone = Marshal.load(Marshal.dump(board))
      current_position = position
      available_moves(position, board).reject do |move|
        board_clone.move_piece(current_position, move)
        current_position = move
        board_clone.king_in_check?(color, move)
      end
    end
  end
end
