module Chess
  module GameState
    def winner?
      checkmate?(current_player.color, board)
    end

    def draw?
      stalemate?(current_player.color, board)
    end

    def game_over?
      winner? || draw?
    end

    def checkmate?(color, board)
      !board.king_can_escape?(color) && board.king_in_check?(color)
    end

    def stalemate?(color, board)
      !board.king_can_escape?(color)
    end
  end
end
