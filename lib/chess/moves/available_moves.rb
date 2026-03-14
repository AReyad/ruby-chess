module Chess
  module AvailableMoves
    LOWEST_BOARD_INDEX = 0
    HIGHEST_BOARD_INDEX = 7

    def available_moves(position, board)
      all_moves(position, board)
        .select { |move| valid_move(move, board) }
    end

    def add_two_moves(first_move, second_move)
      [first_move[0] + second_move[0], first_move[1] + second_move[1]]
    end

    def all_moves(position, board)
      return consecutive_moves(position, board) if moves_consecutively?

      regular_moves(position)
    end

    def consecutive_moves(position, board)
      result = []
      consecutive_move_set.each do |move|
        current_step = position
        loop do
          current_step = add_two_moves(move, current_step)
          result << current_step

          break if blocked_piece?(current_step, board)
        end
      end
      result
    end

    def regular_moves(position)
      result = []
      regular_move_set.each do |move|
        current_step = position
        move.each do |step|
          current_step = add_two_moves(step, current_step)
        end
        result << current_step
      end
      result
    end

    def blocked_piece?(position, board)
      !move_within_range?(position) || board.occupied_square?(position)
    end

    def team_occupied_square?(position, board)
      other_piece = board.at(position)
      color == other_piece&.color
    end

    def valid_move(move, board)
      move_within_range?(move) && !team_occupied_square?(move, board)
    end

    def move_within_range?(move)
      move[0].between?(LOWEST_BOARD_INDEX, HIGHEST_BOARD_INDEX) &&
        move[1].between?(LOWEST_BOARD_INDEX, HIGHEST_BOARD_INDEX)
    end
  end
end
