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
    position = convert_move(position) if position.is_a?(String)
    row = position[0]
    col = position[1]
    board[row][col]
  end

  private

  attr_reader :board
end
