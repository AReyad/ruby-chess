require_relative '../../lib/chess'
describe Chess::Bishop do
  describe '#safe_moves' do
    context 'when a bishop moves' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/3P4/8/5B2/8/PP1PPP1P/RNBQK1NR w KQkq - 0 1') }
      it 'it is free to move diagonally until it is blocked' do
        bishop_position = Chess::MoveConverter.convert_move('f4')
        bishop = board.at(bishop_position)
        moves = bishop.safe_moves(bishop_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e3, e5, g3, g5, h6'
        expect(result).to eq expected_moves
      end
    end

    context 'when a bishop is blocked by an opponent piece' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/ppppPppp/8/8/5B2/8/PP1PPP1P/RNBQK1NR w KQkq - 0 1') }
      it 'it can capture it' do
        bishop_position = Chess::MoveConverter.convert_move('f4')
        bishop = board.at(bishop_position)
        moves = bishop.safe_moves(bishop_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'c7, d6, e3, e5, g3, g5, h6'
        expect(result).to eq expected_moves
      end
    end

    context 'when a bishop can put king in check if moved' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/ppppPppp/8/5q2/5B2/5K2/PP1PPP1P/RNBQ2NR w kq - 0 1') }
      it 'it wont have any moves' do
        bishop_position = Chess::MoveConverter.convert_move('f4')
        bishop = board.at(bishop_position)
        moves = bishop.safe_moves(bishop_position, board)
        result = moves
        expected_moves = []
        expect(result).to eq expected_moves
      end
    end

    context 'when bishop moves can put a king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/ppppPppp/8/4q3/5B2/6K1/PP1PPP1P/RNBQ2NR w kq - 0 1') }
      it 'they are excluded' do
        bishop_position = Chess::MoveConverter.convert_move('f4')
        bishop = board.at(bishop_position)
        moves = bishop.safe_moves(bishop_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e5'
        expect(result).to eq expected_moves
      end
    end
  end
end
