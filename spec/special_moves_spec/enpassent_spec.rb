require_relative '../../lib/chess'
describe 'Chess::EnPassent' do
  describe '#enpassent_to_capture' do
    context 'when enpassent is white pawn on a4' do
      subject(:white_enpassent_board) { Chess::ChessBoard.new }
      it 'returns a3' do
        position = Chess::MoveConverter.convert_move('a2')
        destination = Chess::MoveConverter.convert_move('a4')
        enpassent_position = white_enpassent_board.enpassent_to_capture(position, destination, white_enpassent_board)
        result = Chess::MoveConverter.convert_move(enpassent_position)
        expect(result).to eq('a3')
      end
    end

    context 'when enpassent is black pawn on a5' do
      subject(:black_enpassent_board) { Chess::ChessBoard.new }
      it 'returns a6' do
        position = Chess::MoveConverter.convert_move('a7')
        destination = Chess::MoveConverter.convert_move('a5')
        enpassent_position = black_enpassent_board.enpassent_to_capture(position, destination, black_enpassent_board)
        result = Chess::MoveConverter.convert_move(enpassent_position)
        expect(result).to eq('a6')
      end
    end
  end
end
