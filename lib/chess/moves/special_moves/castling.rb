module Chess
  module Castling
    BLACK_KING_POSITION = [0, 4].freeze
    WHITE_KING_POSITION = [7, 4].freeze

    CASTLING_MOVES = { 'k' => [0, 1], 'q' => [0, 6], 'K' => [7, 1], 'Q' => [7, 6] }.freeze
    def castlable?(color, board, position)
      castlable_queenside?(color, board, position) || castlable_kingside?(color, board, position)
    end

    def white_castling_moves(color, board, position)
      return [CASTLING_MOVES['K'], CASTLING_MOVES['Q']] if castlable?(color, board, position)

      return CASTLING_MOVES['K'] if castlable_kingside?(color, board, position)

      CASTLING_MOVES['Q'] if castlable_queenside?(color, board, position)
    end

    def black_castling_moves(color, board, position)
      return CASTLING_MOVES['k'], CASTLING_MOVES['q'] if castlable?(color, board, position)

      return CASTLING_MOVES['k'] if castlable_kingside?(color, board, position)

      CASTLING_MOVES['q'] if castlable_queenside?(color, board, position)
    end

    def castlable_queenside?(color, board, position)
      queen_rook_reachable?(board, position) && queen_rights?(color, board)
    end

    def castlable_kingside?(color, board, position)
      king_rook_reachable?(board, position) && king_rights?(color, board)
    end

    def king_rook_reachable?(board, position)
      row = position[0]
      col = position[1]
      !board.occupied_square?([row, col - 1]) && !board.occupied_square?([row, col - 2])
    end

    def queen_rook_reachable?(board, position)
      row = position[0]
      col = position[1]
      !board.occupied_square?([row, col + 1]) && !board.occupied_square?([row, col + 2])
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

    def castling(color, position, destination)
      rook_position = rook_position(destination)
      rook_destination = rook_destination(color, destination)
      move_piece(position, destination)
      move_piece(rook_position, rook_destination)
    end

    def rook_position(destination)
      row = destination[0]
      col = destination[1]
      return [row, col - 1] if col == 1

      [row, col + 1]
    end

    def rook_destination(color, position)
      king_position = default_king_position(color)
      row = king_position[0]
      col = king_position[1]
      return [row, col - 1] if position[1] == 1

      [row, col + 1]
    end

    def castling_move?(color, position, destination)
      position == default_king_position(color) && destination[1] == 1 || destination[1] == 6
    end
  end
end
