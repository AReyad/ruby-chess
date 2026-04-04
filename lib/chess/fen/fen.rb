require_relative 'fen_converter'
require_relative 'fen_data_handler'
module Chess
  class Fen
    include FenConverter
    def initialize(data = INITIAL_FEN_HASH, threefold = [])
      @data = handle_data(data)
      @threefold = threefold
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
      update_turn
      threefold << data.values.first(4).join(' ')
    end

    def enpassent
      return if data['enpassent'] == '-'

      data['enpassent']
    end

    def repeated_regular_moves?(half_amount = 100, full_amount = 45)
      data['halfmove'] == half_amount && data['fullmove'] > full_amount
    end

    def to_board
      generate_board(data['placement'])
    end

    def update_placement(placement)
      data['placement'] = placement
    end

    def repeated_states?(amount = 3)
      positions = threefold
      positions.tally[positions.last] == amount
    end

    def turn
      return 1 if data['turn'] == 'b'

      0
    end

    private

    include FenDataHandler
    attr_accessor :data, :threefold
  end
end
