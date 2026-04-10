require_relative 'fen_converter'
require_relative 'fen_data_handler'
module Chess
  class Fen
    include FenConverter
    include FenDataHandler

    def initialize(data = INITIAL_FEN_HASH, states = [])
      @data = handle_data(data)
      @states = states << @data.values.first(4).join(' ')
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
      return if data['castling'] == '-'

      data['castling']
    end

    def update(position, destination, board)
      update_enpassent(position, destination, board)
      update_halfmove(position, destination, board)
      increase_fullmove
      update_castling_rights(position, board)
      update_turn
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
      current_states = states
      current_states.tally[current_states.last] == amount
    end

    def update_states(placement)
      update_placement(placement)
      states << data.values.first(4).join(' ')
    end

    def turn
      return 'black' if data['turn'] == 'b'

      'white'
    end

    private

    attr_accessor :data, :states
  end
end
