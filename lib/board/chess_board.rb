require_relative 'display_board'
require_relative 'piece_handler'
require_relative '../moves/move_converter'

class ChessBoard
  include DisplayBoard
  include MoveConverter
  include PieceHandler

  def initialize(board = Fen.generate_board)
    @board = board
  end

  def display
    puts ''
    display_board(board)
    print COLUMNS_LABELS
  end

  def at(position)
    position = convert_move(position) if position.is_a?(String)
    row = position[0]
    col = position[1]
    board[row][col]
  end

  def occupied_square?(position)
    !at(position).nil?
  end

  def selectable?(position, color)
    piece = at(position)
    can_move?(position, piece) && piece_match_color?(piece, color)
  end

  private

  def change_value(position, value)
    board[position[0]][position[1]] = value
  end

  attr_reader :board
end
