require_relative '../../lib/chess'
describe Chess::Queen do
  describe '#safe_moves' do
    context 'when a queen moves' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/ppppPppp/8/4q3/5B2/6K1/PP1PPP1P/RNBQ2NR b kq - 0 1') }
      it 'it is free to move in all directions until it is blocked' do
        queen_position = Chess::MoveConverter.convert_move('e5')
        queen = board.at(queen_position)
        moves = queen.safe_moves(queen_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'a5, b2, b5, c3, c5, d4, d5, d6, e2, e3, e4, e6, e7, f4, f5, f6, g5, h5'
        expect(result).to eq expected_moves
      end
    end

    context 'when queen moves can put a king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb2bnr/pppkPppp/8/3q4/3Q4/4B3/PP1PPP1P/RNBK2NR b - - 0 1') }
      it 'they are excluded' do
        queen_position = Chess::MoveConverter.convert_move('d5')
        queen = board.at(queen_position)
        moves = queen.safe_moves(queen_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'd4, d6'
        expect(result).to eq expected_moves
      end
    end
  end
end
