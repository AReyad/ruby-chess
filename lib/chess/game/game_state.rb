module Chess
  module GameState
    def winner?
      checkmate?(current_player.color, board)
    end

    def draw?
      stalemate?(current_player.color, board) || board.threefold? || agree_on_draw?
    end

    def game_over?
      winner? || draw?
    end

    def checkmate?(color, board)
      !board.king_can_escape?(color) && board.king_in_check?(color)
    end

    def stalemate?(color, board)
      !board.king_can_escape?(color) && !board.king_in_check?(color)
    end

    def agree_on_draw?
      return unless board.fifty_moves?

      puts '=> Do you want to end the game with a draw? Y\N?'
      print '=> '
      %w[yes y ye yea yeah draw].include? gets.chomp
    end
  end
end
