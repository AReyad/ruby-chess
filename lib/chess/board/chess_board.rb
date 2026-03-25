require_relative 'display_board'
require_relative 'piece_handler'
require_relative '../moves/move_converter'

module Chess
  class ChessBoard
    include DisplayBoard
    include MoveConverter
    include PieceHandler
    include MovesHandler

    def initialize(board = Fen.generate_board, fen = Fen.new)
      @game_board = board
      @fen = fen
    end

    def display(board = game_board)
      system 'clear'
      display_board(board)
      print COLUMNS_LABELS
    end

    def at(position)
      position = convert_move(position) if position.is_a?(String)
      row = position[0]
      col = position[1]
      game_board[row][col]
    end

    def occupied_square?(position)
      !at(position).nil?
    end

    def enpassent_square?(position)
      enpassent_square = fens.enpassent
      return false if enpassent_square.nil?

      convert_move(enpassent_square) == position
    end

    def castling_rights?(side)
      @fen.has_castling_rights?(side)
    end

    def selectable?(position, color)
      piece = at(position)
      return false if piece.nil?

      can_move?(position, piece) && piece_match_color?(piece, color)
    end

    def valid_move?(moves, move)
      moves.include?(move)
    end

    def clone(obj)
      Marshal.load(Marshal.dump(obj))
    end

    private

    def change_value(position, value)
      game_board[position[0]][position[1]] = value
    end

    attr_reader :game_board, :fens
  end
end
