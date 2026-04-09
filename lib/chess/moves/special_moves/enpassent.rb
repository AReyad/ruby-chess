module Chess
  module EnPassent
    def enpassent_position(position, color)
      return white_enpassent_position(position) if color == 'white'

      black_enpassent_position(position)
    end

    def white_enpassent_position(position)
      [position[0] + 1, position[1]]
    end

    def black_enpassent_position(position)
      [position[0] - 1, position[1]]
    end

    def enpassent_to_capture(position, destination, board)
      piece = board.at(position)
      enpassent_position(destination, piece.color)
    end
  end
end
