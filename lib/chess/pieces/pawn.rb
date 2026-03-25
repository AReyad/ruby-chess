module Chess
  class Pawn < Piece
    def piece_directions
      if white?
        { first_move: [%i[north], %i[north north]],
          regular_move: [%i[north]],
          capture_move: [%i[north_west], %i[north_east]] }
      else
        { first_move: [%i[south], %i[south south]],
          regular_move: [%i[south]],
          capture_move: [%i[south_west], %i[south_east]] }
      end
    end

    def all_moves(position, board)
      result = regular_moves(position, board, :first_move) unless moved?(position)

      result = regular_moves(position, board, :regular_move) if moved?(position)
      result + capture_moves(position, board)
    end

    def moved?(position)
      row = position[0]
      return row != STARTING_ROW_BLACK if black?

      row != STARTING_ROW_WHITE
    end

    def enpassent?(position, destination)
      current_row = position[0]
      destination_row = destination[0]
      return current_row == STARTING_ROW_BLACK && destination_row == STARTING_ROW_BLACK + 2 if color == 'black'

      current_row == STARTING_ROW_WHITE && destination_row == STARTING_ROW_WHITE - 2
    end

    private

    STARTING_ROW_BLACK = 1
    STARTING_ROW_WHITE = 6

    def move_set(move)
      piece_directions[move].map do |direction|
        direction.map { |move| ALL_DIRECTIONS[move] }
      end
    end

    def regular_moves(position, board, move_type)
      result = []
      move_set(move_type).each do |move|
        current_step = position
        move.each do |step|
          current_step = add_two_moves(step, current_step)
          break if board.occupied_square?(current_step)
        end
        result << current_step unless board.occupied_square?(current_step)
      end
      result
    end

    def capture_moves(position, board)
      result = []
      move_set(:capture_move).each do |move|
        current_step = position
        move.each do |step|
          current_step = add_two_moves(step, current_step)
        end
        result << current_step if board.occupied_square?(current_step) || board.enpassent_square?(current_step)
      end
      result
    end
  end
end
