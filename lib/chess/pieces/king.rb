module Chess
  class King < Piece
    DIRECTIONS = [[:north_east], [:north], [:north_west], [:west], [:south_west],
                  [:south], [:south_east], [:east]].freeze

    def safe_king_moves(position, board)
      available_moves(position, board)
        .reject { |move| board.king_in_check?(color, move) }
    end
  end
end
