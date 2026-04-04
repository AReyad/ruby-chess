require_relative 'display_board'
require_relative 'piece_handler'
require_relative '../moves/move_converter'

module Chess
  class ChessBoard
    include DisplayBoard
    include MoveConverter
    include PieceHandler
    include MovesHandler

    def initialize(fen_data = Fen::INITIAL_FEN_HASH)
      @fen = Fen.new(fen_data)
      @game_board = fen.to_board
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
      enpassent_square = fen.enpassent
      return false if enpassent_square.nil?

      convert_move(enpassent_square) == position
    end

    def castling_rights?(side)
      fen.castling_rights.include?(side)
    end

    def selectable?(position, color)
      piece = at(position)
      return false if piece.nil?

      can_move?(position, piece) && piece_match_color?(piece, color)
    end

    def valid_move?(moves, move)
      moves.include?(move)
    end

    def clone(obj = self)
      Marshal.load(Marshal.dump(obj))
    end

    def fen_string
      fen.create_fen_string
    end

    def claimable_draw?
      threefold? || fifty_moves?
    end

    def asserted_draw?
      fen.repeated_regular_moves?(125, 75) || fen.repeated_states?(5)
    end

    def starting_player
      fen.turn
    end

    def placement_string
      fen.board_to_fen(game_board)
    end

    private

    def threefold?
      fen.repeated_states?
    end

    def fifty_moves?
      fen.repeated_regular_moves?
    end

    def change_value(position, value)
      game_board[position[0]][position[1]] = value
    end

    attr_reader :game_board, :fen
  end
end
