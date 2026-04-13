require_relative '../lib/chess'

describe Chess::ChessBoard do
  describe '#at' do
    subject(:at_board) { described_class.new }

    context 'when the move is d1' do
      it 'returns white queen' do
        position = at_board.at('d1')
        name_result = position.name
        expect(name_result).to eq('queen')
        color_result = position.color
        expect(color_result).to eq('white')
      end
    end

    context 'when the move is d8' do
      it 'returns black queen' do
        position = at_board.at('d8')
        name_result = position.name
        expect(name_result).to eq('queen')
        color_result = position.color
        expect(color_result).to eq('black')
      end
    end
  end

  describe '#occupied_square?' do
    subject(:occupied_board) { described_class.new }

    context 'when a square is occupied' do
      it 'returns true' do
        result = occupied_board.occupied_square?('d8')
        expect(result).to be true
      end
    end

    context 'when a square is not occupied' do
      it 'returns false' do
        result = occupied_board.occupied_square?('d4')
        expect(result).to be false
      end
    end
  end

  describe '#selectable?' do
    subject(:select_board) { described_class.new }

    context 'when a piece is free to move and of same color' do
      it 'returns true' do
        position = Chess::MoveConverter.convert_move('a2')
        color = 'white'
        result = select_board.selectable?(position, color)
        expect(result).to be true
      end
    end

    context 'when a piece is not free to move and of same color' do
      it 'returns false' do
        position = Chess::MoveConverter.convert_move('a1')
        color = 'white'
        result = select_board.selectable?(position, color)
        expect(result).to be false
      end
    end

    context 'when a piece is free to move and is not of same color' do
      it 'returns false' do
        position = Chess::MoveConverter.convert_move('a7')
        color = 'white'
        result = select_board.selectable?(position, color)
        expect(result).to be false
      end
    end

    context 'when a square is empty' do
      it 'returns false' do
        position = Chess::MoveConverter.convert_move('a7')
        color = 'white'
        result = select_board.selectable?(position, color)
        expect(result).to be false
      end
    end

    context 'when a king is in check' do
      subject(:in_check_board) { described_class.new('rnbqkbnr/ppp2ppp/8/3pP3/4K3/8/PPPP1PPP/RNBQ1BNR w kq d6 0 1') }
      it 'returns true if piece is king or a piece capable of defending the king' do
        king_position = Chess::MoveConverter.convert_move('e4')
        color = 'white'
        result = in_check_board.selectable?(king_position, color)
        expect(result).to be true
        pawn_position = Chess::MoveConverter.convert_move('e5')
        color = 'white'
        result = in_check_board.selectable?(pawn_position, color)
        expect(result).to be true
        queen_position = Chess::MoveConverter.convert_move('d1')
        color = 'white'
        result = in_check_board.selectable?(queen_position, color)
        expect(result).to be false
      end
    end
  end

  describe '#enpassent_square?' do
    context 'when a pawn is enpassent' do
      subject(:has_enpassent_board) do
        described_class.new('rnbqkbnr/ppp2ppp/8/3pP3/4K3/8/PPPP1PPP/RNBQ1BNR w kq d6 0 1')
      end
      it 'returns true' do
        position = Chess::MoveConverter.convert_move('d6')
        result = has_enpassent_board.enpassent_square?(position)
        expect(result).to be true
      end
    end

    context 'when there is no enpassent' do
      subject(:no_enpassent_board) do
        described_class.new('rnbqkbnr/ppp2ppp/8/3pP3/4K3/8/PPPP1PPP/RNBQ1BNR w kq - 0 1')
      end
      it 'returns true' do
        position = Chess::MoveConverter.convert_move('d6')
        result = no_enpassent_board.enpassent_square?(position)
        expect(result).to be false
      end
    end
  end
end
