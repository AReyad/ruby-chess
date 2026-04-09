module Chess
  module Castling
    BLACK_KING_POSITION = [0, 4].freeze
    WHITE_KING_POSITION = [7, 4].freeze

    CASTLING_MOVES = { 'k' => [0, 6], 'q' => [0, 2], 'K' => [7, 6], 'Q' => [7, 2] }.freeze
    def castlable?(color, board, position)
      castlable_queenside?(color, board, position) || castlable_kingside?(color, board, position)
    end

    def both_sides_castlable?(color, board, position)
      castlable_queenside?(color, board, position) && castlable_kingside?(color, board, position)
    end

    def castling_moves(color, board, position)
      king_side = 'K'
      queen_side = 'Q'
      king_side = king_side.downcase if color == 'black'
      queen_side = queen_side.downcase if color == 'black'
      return CASTLING_MOVES[king_side], CASTLING_MOVES[queen_side] if both_sides_castlable?(color, board, position)

      return CASTLING_MOVES[king_side] if castlable_kingside?(color, board, position)

      CASTLING_MOVES[queen_side] if castlable_queenside?(color, board, position)
    end

    def castlable_queenside?(color, board, position)
      queen_rook_reachable?(board, position) && queen_rights?(color, board)
    end

    def castlable_kingside?(color, board, position)
      king_rook_reachable?(board, position) && king_rights?(color, board)
    end

    def king_rook_reachable?(board, position)
      reachable_square?(board, position, 1) && reachable_square?(board, position, 2)
    end

    def queen_rook_reachable?(board, position)
      reachable_square?(board, position,
                        -1) && reachable_square?(board, position, -2) && reachable_square?(board, position, -3)
    end

    def reachable_square?(board, position, incrementor)
      row = position[0]
      col = position[1]
      !board.occupied_square?([row, col + incrementor])
    end

    def default_king_position(color)
      return WHITE_KING_POSITION if color == 'white'

      BLACK_KING_POSITION
    end

    def king_rights?(color, board)
      return board.castling_rights?('K') if color == 'white'

      board.castling_rights?('k')
    end

    def queen_rights?(color, board)
      return board.castling_rights?('Q') if color == 'white'

      board.castling_rights?('q')
    end

    def castling(position, destination)
      rook_position = rook_position(destination)
      rook_destination = rook_destination(destination)
      move_piece(position, destination)
      move_piece(rook_position, rook_destination)
    end

    def rook_position(destination)
      row = destination[0]
      col = destination[1]
      return [row, col - 2] if col == 2

      [row, col + 1]
    end

    def rook_destination(destination)
      row = destination[0]
      col = destination[1]
      return [row, col + 1] if col == 2

      [row, col - 1]
    end

    def castling_move?(color, position, destination)
      position == default_king_position(color) && destination[1] == 2 || destination[1] == 6
    end
  end
end
