class ChessBoard
  include DisplayBoard
  include MoveConverter

  def initialize(board = Fen.generate_board)
    @board = board
  end

  def display
    puts ''
    display_board(board)
    print COLUMNS_LABELS
  end

  def at(position)
    row = position[0]
    col = position[1]
    board[row][col]
  end

  def occupied_square?(position)
    row = position[0]
    col = position[1]
    !board[row][col].nil?
  end

  private

  attr_reader :board
end
