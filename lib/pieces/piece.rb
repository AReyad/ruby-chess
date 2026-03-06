require_relative 'chess_symbols'

class Piece
  attr_reader :color, :symbol, :name, :moves

  include Move
  include ChessSymbols

  ALL_DIRECTIONS = { north: [-1, 0], east: [0, 1],
                     west: [0, -1], south: [1, 0],
                     north_east: [-1, 1], north_west: [-1, -1],
                     south_east: [1, 1], south_west: [1, -1] }.freeze

  PIECE_COLORS = { 'black' => '0;0;0', 'white' => '255;255;255' }.freeze

  def initialize(color)
    @name = self.class.to_s.downcase
    @color = color
    @symbol = chess_symbol
    @moves = 0
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

  def moved?
    moves.positive?
  end

  def increment_moves
    @moves += 1
  end

  def to_s
    Colorize.foreground(PIECE_COLORS[color], symbol)
  end

  private

  def chess_symbol
    CHESS_SYMBOLS[name]
  end
end
