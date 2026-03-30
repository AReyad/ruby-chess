require_relative 'fen_converter'
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

    private

    def handle_data(data)
      return data if data.is_a?(Hash)

      create_fen_hash(data)
    end

    def update_turn
      return data['turn'] = 'b' if data['turn'] == 'w'

      data['turn'] = 'w'
    end

    def update_halfmove(position, destination, board)
      piece = board.at(position)
      return data['halfmove'] += 1 if can_update_halfmove?(piece, destination)

      data['halfmove'] = 0
    end

    def can_update_halfmove?(piece, destination)
      !piece.pawn? && !destination.nil?
    end

    def increase_fullmove
      data['fullmove'] += 1 if data['turn'] == 'b'
    end

    def update_castling_rights(position, board)
      piece = board.at(position)
      col = position[1]
      return update_king_rights(piece) if piece.king?

      return update_queenside_rights(piece) if col.zero? && piece.name == 'rook'

      update_kingside_rights(piece) if col == 7 && piece.name == 'rook'
    end

    def update_kingside_rights(piece)
      return data['castling'].delete!('K') if piece.white?

      data['castling'].delete!('k') if piece.black?
    end

    def update_queenside_rights(piece)
      return data['castling'].delete!('Q') if piece.white?

      data['castling'].delete!('q') if piece.black?
    end

    def update_king_rights(piece)
      return data['castling'].delete!('KQ') if piece.white?

      data['castling'].delete!('kq') if piece.black?
    end

    def update_enpassent(position, destination, board)
      data['enpassent'] = '-'

      piece = board.at(position)
      return unless piece.pawn? && piece.enpassent?(position, destination)

      enpassent_position = board.enpassent_position(destination, piece.color)
      data['enpassent'] = MoveConverter.convert_move(enpassent_position)
    end

    attr_accessor :data
  end
end
