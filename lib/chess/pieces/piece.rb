require_relative 'chess_symbols'
require_relative '../moves/available_moves'

module Chess
  class Piece
    attr_reader :color, :symbol, :name

    include AvailableMoves
    include ChessSymbols

    ALL_DIRECTIONS = { north: [-1, 0], east: [0, 1],
                       west: [0, -1], south: [1, 0],
                       north_east: [-1, 1], north_west: [-1, -1],
                       south_east: [1, 1], south_west: [1, -1] }.freeze

    def initialize(color)
      @name = piece_name
      @color = color
      @symbol = piece_symbol
    end

    def safe_moves(position, board)
      king_position = board.find_king(color)
      opponent_positions = board.opponent_positions(color)
      available_moves(position, board).reject do |move|
        destination_value = board.at(move)
        simulate_move(position, move, board)
        check = board.king_in_check?(color, king_position, opponent_positions)
        board.reset_move(position, move, destination_value)
        check
      end
    end

    def piece_directions
      self.class::DIRECTIONS
    end

    def regular_move_set
      piece_directions.map do |direction|
        direction.map { |move| ALL_DIRECTIONS[move] }
      end
    end

    def consecutive_move_set
      piece_directions.map do |direction|
        ALL_DIRECTIONS[direction]
      end
    end

    def moves_consecutively?
      %w[rook bishop queen].include?(name)
    end

    def moves_regularly?
      %w[knight king].include?(name)
    end

    def white?
      color == 'white'
    end

    def black?
      color == 'black'
    end

    def pawn?
      name == 'pawn'
    end

    def king?
      name == 'king'
    end

    def symbol_for_highlight
      "\e[38;2;#{piece_color}m#{symbol} \e[0m"
    end

    def to_s
      Colorize.foreground(piece_color, symbol)
    end

    private

    def simulate_move(position, move, board)
      board.capture_enpassent(position, move) if board.at(position)&.pawn? && board.enpassent_square?(move)
      board.move_piece(position, move)
    end

    def piece_name
      name = self.class.to_s.downcase
      name.split(':')[2]
    end

    def piece_color
      Palette.color(color)
    end

    def piece_symbol
      CHESS_SYMBOLS[name]
    end
  end
end
