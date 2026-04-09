require_relative 'game_state'
require_relative 'selection'
require_relative 'save_game'

module Chess
  class Game
    include Selection
    include GameState
    include SaveGame

    def initialize(board = ChessBoard.new, players = create_players)
      @board = board
      players.rotate! if board.starting_player == 1
      @players = players
      @current_player = players[0]
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

    def end_message
      board.display
      return 'Game ended with a draw' if draw?

      "Congratulations, #{players[1].name} won!"
    end

    private

    def create_players
      players = []
      current_color = 'white'
      2.times do
        name = current_color.capitalize
        players << Player.new(name, current_color)
        current_color = 'black'
      end
      players
    end

    def switch_players!
      players.rotate!
      @current_player = players[0]
    end
    attr_reader :current_player, :players, :board
  end
end
