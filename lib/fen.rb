module Fen
  INITIAL_PIECE_PLACEMENT = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  CHESS_PIECES_NOTATION = { 'n' => Knight.new('black'), 'r' => Rook.new('black'), 'b' => Bishop.new('black'),
                            'q' => Queen.new('black'), 'k' => King.new('black'), 'p' => Pawn.new('black'),
                            'N' => Knight.new('white'), 'R' => Rook.new('white'), 'B' => Bishop.new('white'),
                            'Q' => Queen.new('white'), 'K' => King.new('white'), 'P' => Pawn.new('white') }.freeze

  module_function

  def board_fen_array(string)
    fen_array = substitute_fen_digits(string).split('/')
    fen_array.map do |string|
      string.split('')
    end
  end

  def generate_board(string = INITIAL_PIECE_PLACEMENT)
    fen_array = board_fen_array(string)
    fen_array.map do |array|
      array.map do |ele|
        ele = CHESS_PIECES_NOTATION[ele]
        ele if CHESS_PIECES_NOTATION[ele].nil?
      end
    end
  end

  def substitute_fen_digits(string)
    string.gsub(/\d/) { |match| ' ' * match.to_i }
  end

  def sum_fen_digits(string)
    string.gsub(/\d+/) do |match|
      sum = 0
      match.each_char do |digit|
        sum += digit.to_i
      end
      sum.to_s
    end
  end

  def board_to_fen(board)
    string = ''
    board.each do |row|
      row.each do |ele|
        key = CHESS_PIECES_NOTATION.key(ele)
        key = '1' if ele.nil?
        string += key
      end
      string += '/'
    end
    sum_fen_digits(string)
  end
end
