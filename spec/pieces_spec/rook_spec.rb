require_relative '../../lib/chess'
describe Chess::Rook do
  describe '#safe_moves' do
    context 'when a rook moves' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppp1ppp/5P2/8/5R2/8/PP1PP2P/RNBQBKN1 w kq - 0 1') }
      it 'it is free to move horizontally or vertically until it is blocked' do
        rook_position = Chess::MoveConverter.convert_move('f4')
        rook = board.at(rook_position)
        moves = rook.safe_moves(rook_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'a4, b4, c4, d4, e4, f2, f3, f5, g4, h4'
        expect(result).to eq expected_moves
      end
    end

    context 'when a rook is blocked by an opponent piece' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppp2pp/5p2/8/5R2/8/PP1PP2P/RNBQBKN1 w kq - 0 1') }
      it 'it can capture it' do
        rook_position = Chess::MoveConverter.convert_move('f4')
        rook = board.at(rook_position)
        moves = rook.safe_moves(rook_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'a4, b4, c4, d4, e4, f2, f3, f5, f6, g4, h4'
        expect(result).to eq expected_moves
      end
    end

    context 'when rook moves can put a king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/pppp2pp/5q2/8/5R2/8/PP1PP2P/RNBQBKN1 w kq - 0 1') }
      it 'they are excluded' do
        rook_position = Chess::MoveConverter.convert_move('f4')
        rook = board.at(rook_position)
        moves = rook.safe_moves(rook_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'f2, f3, f5, f6'
        expect(result).to eq expected_moves
      end
    end

    context 'when a rook can put a king in check if moved' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/pppp2pp/8/6q1/5R2/4K3/PP1PP2P/RNBQB1N1 w kq - 0 1') }
      it 'it wont have any moves' do
        rook_position = Chess::MoveConverter.convert_move('f4')
        rook = board.at(rook_position)
        moves = rook.safe_moves(rook_position, board)
        result = moves
        expected_moves = []
        expect(result).to eq expected_moves
      end
    end
  end
end
