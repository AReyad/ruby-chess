module Chess
  # Converts Fen Placement string to board and board to Fen Placement string
  module FenConverter
    INITIAL_PIECE_PLACEMENT = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'.freeze

    PIECES_NOTATION = { 'n' => { name: Chess::Knight, color: 'black' }, 'r' => { name: Chess::Rook, color: 'black' },
                        'b' => { name: Chess::Bishop, color: 'black' }, 'q' => { name: Chess::Queen, color: 'black' },
                        'k' => { name: Chess::King, color: 'black' },   'p' => { name: Chess::Pawn, color: 'black' },
                        'N' => { name: Chess::Knight, color: 'white' }, 'R' => { name: Chess::Rook, color: 'white' },
                        'B' => { name: Chess::Bishop, color: 'white' }, 'Q' => { name: Chess::Queen, color: 'white' },
                        'K' => { name: Chess::King, color: 'white' },   'P' => { name: Chess::Pawn, color: 'white' } }.freeze

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
      board.each do |row|
        row.each do |ele|
          key = PIECES_NOTATION.key({ name: ele.class, color: ele&.color })
          key = '1' if ele.nil?
          string += key
        end
        string += '/'
      end
      sum_fen_digits(string)
    end
  end
end
