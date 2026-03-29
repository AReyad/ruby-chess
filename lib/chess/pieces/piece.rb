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
      @symbol = chess_symbol
    end

    def safe_moves(position, board)
      board_clone = board.clone
      current_position = position
      king_position = board_clone.find_king(color)
      opponent_positions = board_clone.opponent_positions(color)
      available_moves(position, board).reject do |move|
        board_clone.move_piece(current_position, move)
        current_position = move
        board_clone.king_in_check?(color, king_position, opponent_positions)
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

    def piece_color
      Palette.color(color)
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

    def piece_name
      name = self.class.to_s.downcase
      name.split(':')[2]
    end

    def chess_symbol
      CHESS_SYMBOLS[name]
    end
  end
end
