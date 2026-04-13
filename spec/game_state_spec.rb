require_relative '../lib/chess'

describe Chess::GameState do
  describe '#stalemate?' do
    context 'when a king cant move but there is any piece that can make a safe move' do
      subject(:not_stalemate_game) { Chess::Game.new }
      subject(:board) { Chess::ChessBoard.new('4k3/7R/4N3/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns false' do
        result = not_stalemate_game.stalemate?('black', board)
        expect(result).to be false
      end
    end

    context 'when a king is in check but it can move and there is not any piece that can make a safe move' do
      subject(:not_stalemate_game) { Chess::Game.new }
      subject(:board) { Chess::ChessBoard.new('4k2R/8/8/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns false' do
        result = not_stalemate_game.stalemate?('black', board)
        expect(result).to be false
      end
    end

    context 'when a king cant move and there is not any piece that can make a safe move' do
      subject(:not_stalemate_game) { Chess::Game.new }
      subject(:board) { Chess::ChessBoard.new('7k/5Q2/6K1/8/8/8/8/8 b - - 0 1') }

      it 'returns true' do
        result = not_stalemate_game.stalemate?('black', board)
        expect(result).to be true
      end
    end
  end

  describe '#checkmate?' do
    context 'when a king cant escape check' do
      subject(:checkmate_game) { Chess::Game.new }
      subject(:black_checkmate_board) { Chess::ChessBoard.new('R5k1/5ppp/8/8/8/8/8/4K3 b - - 1 1') }
      subject(:white_checkmate_board) { Chess::ChessBoard.new('rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3') }

      it 'returns true' do
        result = checkmate_game.checkmate?('black', black_checkmate_board)
        expect(result).to be true
        result = checkmate_game.checkmate?('white', white_checkmate_board)
        expect(result).to be true
      end
    end

    context 'when a king cant move but is not in check' do
      subject(:not_checkmate_game) { Chess::Game.new }
      subject(:board) { Chess::ChessBoard.new('4k3/7R/4N3/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns false' do
        result = not_checkmate_game.checkmate?('black', board)
        expect(result).to be false
      end
    end

    context 'when a king can move but is in check' do
      subject(:not_checkmate_game) { Chess::Game.new }
      subject(:board) { Chess::ChessBoard.new('4k2R/8/8/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns false' do
        result = not_checkmate_game.checkmate?('black', board)
        expect(result).to be false
      end
    end
  end
end
