require_relative 'fen_constants'
module Chess
  # Converts Fen Placement string to board and board to Fen Placement string
  module FenConverter
    include FenConstants
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
      CreatePiece.piece(PIECES_NOTATION[letter][:name], PIECES_NOTATION[letter][:color])
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
      board.each_with_index do |row, index|
        row.each do |ele|
          key = PIECES_NOTATION.key({ name: ele.class, color: ele&.color })
          key = '1' if ele.nil?
          string += key
        end
        string += '/' unless index == 7
      end
      sum_fen_digits(string)
    end
  end
end
