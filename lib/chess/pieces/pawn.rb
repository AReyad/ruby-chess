module Chess
  class Pawn < Piece
    def piece_directions
      if color == 'white'
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
      result = regular_moves(position, board, :first_move) unless moved?

      result = regular_moves(position, board, :regular_move) if moved?
      result + capture_moves(position, board)
    end

    private

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
          break if blocked_piece?(current_step, board)
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
        result << current_step if board.occupied_square?(current_step)
      end
      result
    end
  end
end
