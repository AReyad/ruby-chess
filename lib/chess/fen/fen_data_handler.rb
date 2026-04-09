module Chess
  module FenDataHandler
    KING_SIDE_CASTLING = 'K'.freeze
    QUEEN_SIDE_CASTLING = 'Q'.freeze

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
      return data['halfmove'] += 1 if can_update_halfmove?(piece, board.at(destination))

      data['halfmove'] = 0
    end

    def can_update_halfmove?(piece, destination)
      !piece.pawn? && destination.nil?
    end

    def increase_fullmove
      data['fullmove'] += 1 if data['turn'] == 'b'
    end

    def update_castling_rights(position, board)
      piece = board.at(position)
      col = position[1]
      return update_king_rights(piece.color) if piece.king?

      return update_queenside_rights(piece.color) if col.zero? && piece.name == 'rook'

      update_kingside_rights(piece.color) if col == 7 && piece.name == 'rook'
    end

    def update_kingside_rights(color)
      return data['castling'].delete!(KING_SIDE_CASTLING) if color == 'white'

      data['castling'].delete!(KING_SIDE_CASTLING.downcase) if color == 'black'
    end

    def update_queenside_rights(color)
      return data['castling'].delete!(QUEEN_SIDE_CASTLING) if color == 'white'

      data['castling'].delete!(QUEEN_SIDE_CASTLING.downcase) if color == 'black'
    end

    def update_king_rights(color)
      side = KING_SIDE_CASTLING + QUEEN_SIDE_CASTLING
      return data['castling'].delete!(side) if color == 'white'

      data['castling'].delete!(side.downcase) if color == 'black'
    end

    def update_enpassent(position, destination, board)
      data['enpassent'] = '-'

      piece = board.at(position)
      return unless piece.pawn? && piece.enpassent?(position, destination)

      enpassent_position = board.enpassent_position(destination, piece.color)
      data['enpassent'] = MoveConverter.convert_move(enpassent_position)
    end

    def update_imported_castling(board)
      update_imported_king_castling(board)
      update_imported_queenside_castling(board)
      update_imported_kingside_castling(board)
      data['castling'] = '-' if data['castling'] == ''
    end

    def update_imported_king_castling(board)
      white_king_position = board.at(Chess.default_piece_position('white', :king))
      black_king_position = board.at(Chess.default_piece_position('black', :king))
      update_king_rights('white') if white_king_position.nil? || !white_king_position.king?
      update_king_rights('black') if black_king_position.nil? || !black_king_position.king?
    end

    def update_imported_queenside_castling(board)
      white_queen_rook_position = board.at(Chess.default_piece_position('white', :queen_rook))
      black_queen_rook_position = board.at(Chess.default_piece_position('black', :queen_rook))
      update_queenside_rights('white') if white_queen_rook_position.nil? || !white_queen_rook_position.name == 'rook'
      update_queenside_rights('black') if black_queen_rook_position.nil? || !black_queen_rook_position.name == 'rook'
    end

    def update_imported_kingside_castling(board)
      white_king_rook_position = board.at(Chess.default_piece_position('white', :king_rook))
      black_king_rook_position = board.at(Chess.default_piece_position('black', :king_rook))
      update_kingside_rights('white') if white_king_rook_position.nil? || !white_king_rook_position.name == 'rook'
      update_kingside_rights('black') if black_king_rook_position.nil? || !black_king_rook_position.name == 'rook'
    end
  end
end
