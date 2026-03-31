module Chess
  module FenDataHandler
    def update_threefold(position, destination)
      reset_threefold
      return data['threefold']['w'] << [position, destination] if data['turn'] == 'w'

      data['threefold']['b'] << [position, destination]
    end

    def reset_threefold
      data['threefold']['w'] = [] if data['threefold']['w'].length == 3
      data['threefold']['b'] = [] if data['threefold']['b'].length == 3
    end

    def two_equal_unique_moves(moves)
      moves == 2 && moves[0].sort == moves[1].sort
    end

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
  end
end
