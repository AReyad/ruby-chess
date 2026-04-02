require_relative './chess/palette'
require_relative './chess/colorize'
require_relative './chess/moves/special_moves/enpassent'
require_relative './chess/moves/special_moves/castling'
require_relative './chess/moves/special_moves/promotion'
require_relative './chess/moves/moves_handler'
require_relative './chess/pieces/piece'
require_relative './chess/pieces/king'
require_relative './chess/pieces/bishop'
require_relative './chess/pieces/pawn'
require_relative './chess/pieces/knight'
require_relative './chess/pieces/queen'
require_relative './chess/pieces/rook'
require_relative './chess/fen/fen'
require_relative './chess/board/chess_board'
require_relative './chess/create_piece'
require_relative './chess/player'
require_relative './chess/cli'
require_relative './chess/game/game'
require_relative './chess/game/game_state'

module Chess
  module_function

  def save_path
    project_dir = File.expand_path('..', __dir__)
    File.join(project_dir, 'save.json')
  end

  def deserialize
    JSON.parse(File.read(save_path))
  end

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

  def load_game
    CLI.load_confirmation
    user_input = gets.chomp.downcase
    return unless user_input == 'y'

    saves = deserialize
    select_load(saves)
  end

  def select_load(saves)
    keys = saves.keys
    return saves[keys[0]] if keys.length == 1

    display_saves(keys)
    loop do
      selected_save = gets.chomp.to_i
      next CLI.invalid_load unless saves[keys[selected_save]]

      return saves[keys[selected_save]]
    end
  end

  def display_saves(saves)
    saves.each_with_index { |key, index| puts "#{index}) #{key}" }
    print '=> Type the number of the save you want to load: '
  end

  def load_file_exists?(file_path)
    File.exist?(file_path) && !File.empty?(file_path)
  end

  def run
    begin
      loaded = load_game if load_file_exists?(save_path)
    rescue StandardError
      return Game.new.play
    end
    return Game.new.play unless loaded

    Game.new(ChessBoard.new(loaded)).play
  end
end

Chess.run
