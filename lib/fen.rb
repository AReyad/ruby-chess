module Fen
  INITIAL_PIECE_PLACEMENT = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  PIECES_NOTATION = { 'n' => { name: Knight, color: 'black' }, 'r' => { name: Rook, color: 'black' },
                      'b' => { name: Bishop, color: 'black' }, 'q' => { name: Queen, color: 'black' },
                      'k' => { name: King, color: 'black' },   'p' => { name: Pawn, color: 'black' },
                      'N' => { name: Knight, color: 'white' }, 'R' => { name: Rook, color: 'white' },
                      'B' => { name: Bishop, color: 'white' }, 'Q' => { name: Queen, color: 'white' },
                      'K' => { name: King, color: 'white' },   'P' => { name: Pawn, color: 'white' } }.freeze

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
        piece(ele) if PIECES_NOTATION[ele]
      end
    end
  end

  def piece(letter)
    CreatePiece.create_piece(PIECES_NOTATION[letter][:name], PIECES_NOTATION[letter][:color])
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
        key = PIECES_NOTATION.key(ele)
        key = '1' if ele.nil?
        string += key
      end
      string += '/'
    end
    sum_fen_digits(string)
  end
end
