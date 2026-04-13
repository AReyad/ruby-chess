require_relative '../../lib/chess'

describe Chess::Promotion do
  describe '#promotable?' do
    context 'when a white pawn is on a8' do
      subject(:pawn_promotion_board) { Chess::ChessBoard.new('P3k2r/8/8/8/8/8/8/4K2R w Kk - 0 1') }
      it 'can be promoted' do
        position = Chess::MoveConverter.convert_move('a8')
        result = pawn_promotion_board.promotable?(position, 'white')
        expect(result).to be true
      end
    end

    context 'when a black pawn is on a1' do
      subject(:pawn_promotion_board) { Chess::ChessBoard.new('P3k2r/8/8/8/8/8/8/p3K2R w Kk - 0 1') }
      it 'can be promoted' do
        position = Chess::MoveConverter.convert_move('a1')
        result = pawn_promotion_board.promotable?(position, 'black')
        expect(result).to be true
      end
    end

    context 'when a non pawn white piece is on a8' do
      subject(:pawn_promotion_board) { Chess::ChessBoard.new('N3k2r/8/8/8/8/8/8/n3K2R w Kk - 0 1') }
      it 'cant be promoted' do
        position = Chess::MoveConverter.convert_move('a8')
        result = pawn_promotion_board.promotable?(position, 'white')
        expect(result).to be nil
      end
    end

    context 'when a non pawn black piece is on a1' do
      subject(:pawn_promotion_board) { Chess::ChessBoard.new('N3k2r/8/8/8/8/8/8/n3K2R w Kk - 0 1') }
      it 'cant be promoted' do
        position = Chess::MoveConverter.convert_move('a1')
        result = pawn_promotion_board.promotable?(position, 'black')
        expect(result).to be nil
      end
    end
  end
end
