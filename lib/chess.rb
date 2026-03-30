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

  def run
    loaded = load_game if File.exist?(Chess.save_path)
    return Game.new.play unless loaded

    players = create_players.reverse if loaded['turn'] == 'b'
    players = create_players if loaded['turn'] == 'w'
    p loaded
    Game.new(ChessBoard.new(loaded), players).play
  end
end
Chess.run
# fen = Chess::Fen.new
# fen2 = Chess::Fen.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 22 33')
# fen3 = Chess::Fen.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - e3 20 11')
# fen4 = Chess::Fen.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - a4 03 15')
# fen5 = Chess::Fen.new('rnbbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - c2 50 17')
# # t = fen.create_fen_hash('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w d - 0 1 {w:[],b:[]}')
# p fen.cloned_data
# p ''
# p fen2.cloned_data
# p ''
# p fen3.cloned_data
# p ''
# p fen4.cloned_data
# p ''
# p fen5.cloned_data
# # p t
# # str = fen.create_fen_string
# # p fen.create_fen_hash(str)
