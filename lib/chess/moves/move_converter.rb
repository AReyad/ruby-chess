module Chess
  module MoveConverter
    FILE_TO_INDEX = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }.freeze

    module_function

    def convert_move(move)
      return convert_algebraic_move(move) if move.is_a?(String)

      convert_coord_move(move)
    end

    def convert_moves(moves)
      moves.map do |move|
        convert_move(move)
      end.join(', ')
    end

    def convert_algebraic_move(string)
      rank = 8 - string[1].to_i
      file = FILE_TO_INDEX[string[0]].to_i
      [rank, file]
    end

    def convert_coord_move(coord)
      rank = (8 - coord[0]).to_s
      file = coord[1]
      algebraic_letter = FILE_TO_INDEX.key(file)
      algebraic_letter + rank
    end
  end
end
