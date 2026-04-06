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
require_relative './chess/serializer'
require_relative './chess/menu_selection'
require_relative './chess/load_game'
require_relative './chess/game/game'
require_relative './chess/game/game_state'

module Chess
  extend MenuSelection
  extend LoadGame

  module_function

  def save_path
    project_dir = File.expand_path('..', __dir__)
    File.join(project_dir, 'save.json')
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
