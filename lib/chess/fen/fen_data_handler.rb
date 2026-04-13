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
      return update_king_rights(piece.color) if piece.king?
      return unless piece.name == 'rook'

      update_side_rights(piece.color, :queen_rook, position)
      update_side_rights(piece.color, :king_rook, position)
    end

    def update_side_rights(color, side, position)
      side_letter = KING_SIDE_CASTLING
      side_letter = QUEEN_SIDE_CASTLING if side == :queen_rook
      default_position = Chess.default_piece_position(color, side)
      delete_castling_right(side_letter, color) if position == default_position
    end

    def update_king_rights(color)
      side = KING_SIDE_CASTLING + QUEEN_SIDE_CASTLING
      delete_castling_right(side, color)
    end

    def reset_castling_rights
      data['castling'] = '-' if data['castling'] == ''
    end

    def update_enpassent(position, destination, board)
      data['enpassent'] = '-'

      piece = board.at(position)
      return unless piece.pawn? && piece.enpassent?(position, destination)

      enpassent_position = board.enpassent_position(destination, piece.color)
      data['enpassent'] = MoveConverter.convert_move(enpassent_position)
    end

    def update_imported_castling(board)
      update_imported_castling_side(board, :queen_rook, QUEEN_SIDE_CASTLING)
      update_imported_castling_side(board, :king_rook, KING_SIDE_CASTLING)
      update_imported_castling_side(board, :king, KING_SIDE_CASTLING + QUEEN_SIDE_CASTLING)
      reset_castling_rights
    end

    def update_imported_castling_side(board, side, side_letter)
      white_position = board.at(Chess.default_piece_position('white', side))
      black_position = board.at(Chess.default_piece_position('black', side))
      piece_name = 'rook'
      piece_name = 'king' if side == :king
      delete_castling_right(side_letter, 'white') if white_position.nil? || white_position.name != piece_name
      delete_castling_right(side_letter, 'black') if black_position.nil? || black_position.name != piece_name
    end

    def delete_castling_right(side_letter, color)
      data['castling'].delete!(side_letter) if color == 'white'
      data['castling'].delete!(side_letter.downcase) if color == 'black'
      reset_castling_rights
    end
  end
end
