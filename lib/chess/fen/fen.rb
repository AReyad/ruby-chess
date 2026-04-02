require_relative 'fen_converter'
require_relative 'fen_data_handler'
module Chess
  class Fen
    include FenConverter
    def initialize(data = INITIAL_FEN_HASH)
      @data = handle_data(data)
    end

    def create_fen_string
      data.values.join(' ')
    end

    def create_fen_hash(string)
      fen_parts = string.split(' ')
      data = {}
      INITIAL_FEN_HASH.each_key.with_index { |key, index| data[key] = fen_parts[index] }
      data['halfmove'] = data['halfmove'].to_i
      data['fullmove'] = data['fullmove'].to_i
      data
    end

    def castling_rights
      data['castling']
    end

    def update(position, destination, board)
      update_enpassent(position, destination, board)
      update_halfmove(position, destination, board)
      increase_fullmove
      update_castling_rights(position, board)
      update_threefold(position, destination)
      update_turn
    end

    def enpassent
      return if data['enpassent'] == '-'

      data['enpassent']
    end

    def cloned_data
      JSON.parse(JSON.dump(data))
    end

    def hundred_regular_moves?
      data['halfmove'] == 100 && data['fullmove'] > 49
    end

    def to_board
      generate_board(data['placement'])
    end

    def update_placement(placement)
      data['placement'] = placement
    end

    def three_repeated_moves?
      black_moves = data['threefold']['b']
      white_moves = data['threefold']['w']

      return true if two_equal_unique_moves?(black_moves.uniq) && black_moves.length > 2

      two_equal_unique_moves?(white_moves.uniq) && white_moves.length > 2
    end

    def turn
      return 1 if data['turn'] == 'b'

      0
    end

    private

    include FenDataHandler
    attr_accessor :data
  end
end
