require_relative '../../lib/chess'
describe Chess::Knight do
  describe '#safe_moves' do
    context 'when a knight moves' do
      subject(:board) { Chess::ChessBoard.new }
      it 'it is can jump over pieces' do
        knight_position = Chess::MoveConverter.convert_move('g8')
        knight = board.at(knight_position)
        moves = knight.safe_moves(knight_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'f6, h6'
        expect(result).to eq expected_moves
      end
    end

    context 'when a knight has a piece on top of its destination' do
      subject(:board) { Chess::ChessBoard.new('rn1qkbnr/pp2pppp/8/b1p5/3p4/1N6/PPPPPPPP/R1BQKBNR w KQkq - 0 1') }
      it 'it can capture it' do
        knight_position = Chess::MoveConverter.convert_move('b3')
        knight = board.at(knight_position)
        moves = knight.safe_moves(knight_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'a5, c5, d4'

        expect(result).to eq expected_moves
      end
    end

    context 'when a knight can put a king in check if moved' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/pppppppp/4q3/8/1P2N3/4K3/PPPP1PPP/R1BQ1BNR w kq - 0 1') }
      it 'it wont have any moves' do
        knight_position = Chess::MoveConverter.convert_move('e4')
        knight = board.at(knight_position)
        moves = knight.safe_moves(knight_position, board)
        result = moves
        expected_moves = []
        expect(result).to eq expected_moves
      end
    end
  end
end
