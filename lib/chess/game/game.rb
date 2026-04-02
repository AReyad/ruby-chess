require_relative 'game_state'
require_relative 'selection'
require_relative 'save'

module Chess
  class Game
    include Selection
    include GameState
    include Save

    def initialize(board = ChessBoard.new, players = Chess.create_players)
      @board = board
      @players = players
      @current_player = players[0]
    end

    def run
      game_load
      play
    end

    def play
      until game_over?

        selected = selection
        return exit_game if selected == 'exit'
        return save if selected == 'save'

        position = selected[:position]
        destination = selected[:destination]
        board.handle_moves(position, destination)

        switch_players!
      end
      puts end_message
    end

    def exit_game
      CLI.save_confirmation
      input = gets.chomp
      return save if %w[yes y ye yea yeah save].include?(input)

      CLI.exited
    end

    def switch_players!
      players.rotate!
      @current_player = players[0]
    end

    def end_message
      return 'Game ended with a draw' if draw?

      "Congratulations, #{current_player.name} won!"
    end

    attr_reader :current_player, :players, :board
  end
end
