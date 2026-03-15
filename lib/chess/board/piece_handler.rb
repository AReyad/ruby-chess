module Chess
  module PieceHandler
    def move_piece(piece_pos, target_pos)
      change_value(target_pos, at(piece_pos))
      change_value(piece_pos, nil)
    end

    def can_move?(position, piece)
      return !piece.safe_king_moves(position, self).empty? if piece_match_name?(piece, 'king')

      !piece.available_moves(position, self).empty?
    end

    def king_in_check?(color, king_position = find_king(color))
      opponent_positions(color).any? do |position|
        at(position).available_moves(position, self).include?(king_position)
      end
    end

    def can_defend_king?(position, color)
      board = Marshal.load(Marshal.dump(self))
      current_position = position
      board.at(position).available_moves(position, board).any? do |move|
        board.move_piece(current_position, move)
        current_position = move
        !board.king_in_check?(color)
      end
    end

    def find_piece_position(color, name)
      result = []
      game_board.find.with_index do |row, row_index|
        row.find.with_index do |piece, piece_index|
          result = [row_index, piece_index] if piece_match?(piece, color, name)
        end
      end
      result
    end

    def find_pieces_positions(color)
      result = []
      game_board.each_with_index do |row, row_index|
        row.each_with_index do |piece, piece_index|
          result << [row_index, piece_index] if piece_match_color?(piece, color)
        end
      end
      result
    end

    def find_king(color)
      find_piece_position(color, 'king')
    end

    def opponent_positions(color)
      find_pieces_positions(opponent_color(color))
    end

    def opponent_color(color)
      return 'black' if color == 'white'

      'white'
    end

    def piece_match?(piece, color, name)
      piece_match_color?(piece, color) && piece_match_name?(piece, name)
    end

    def piece_match_color?(piece, color)
      piece&.color == color
    end

    def piece_match_name?(piece, name)
      piece&.name == name
    end
  end
end
