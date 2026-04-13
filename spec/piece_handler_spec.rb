require_relative '../lib/chess'

describe Chess::PieceHandler do
  describe '#can_move?' do
    context 'when a white piece is surrounded by white pieces' do
      subject(:can_move_board) { Chess::ChessBoard.new }
      it 'cant move' do
        rook_position = Chess::MoveConverter.convert_move('a1')
        bishop_position = Chess::MoveConverter.convert_move('c1')
        queen_position = Chess::MoveConverter.convert_move('d1')
        king_position = Chess::MoveConverter.convert_move('e1')
        rook_result = can_move_board.can_move?(rook_position)
        bishop_result = can_move_board.can_move?(bishop_position)
        queen_result = can_move_board.can_move?(queen_position)
        king_result = can_move_board.can_move?(king_position)

        expect(rook_result).to be false
        expect(bishop_result).to be false
        expect(queen_result).to be false
        expect(king_result).to be false
      end
    end

    context 'when a knight is surrounded by team pieces' do
      subject(:can_move_board) { Chess::ChessBoard.new }
      it 'can move' do
        knight_position = Chess::MoveConverter.convert_move('b1')
        knight_result = can_move_board.can_move?(knight_position)

        expect(knight_result).to be true
      end
    end

    context 'when black king is in check and cannot be defended by any team pieces' do
      subject(:king_incheck_board) { Chess::ChessBoard.new('n3k3/8/8/8/8/8/8/K3R3 b - - 0 1') }

      it 'returns false for all black piece except black king' do
        black_knight_position = Chess::MoveConverter.convert_move('a8')
        black_king_position = Chess::MoveConverter.convert_move('e8')
        black_knight_result = king_incheck_board.can_move?(black_knight_position)
        black_king_result = king_incheck_board.can_move?(black_king_position)

        expect(black_king_result).to be true
        expect(black_knight_result).to be false
      end
    end
  end

  describe '#team_can_move?' do
    context 'when king cant make any safe moves' do
      subject(:surrounded_king_board) { Chess::ChessBoard.new('7k/6Q1/6K1/8/8/8/8/8 b - - 0 1') }
      it 'return false' do
        white_king_result = surrounded_king_board.team_can_move?('white')
        black_king_result = surrounded_king_board.team_can_move?('black')

        expect(white_king_result).to be true
        expect(black_king_result).to be false
      end
    end

    context 'when a piece can defend king' do
      subject(:defend_king_board) { Chess::ChessBoard.new('4k3/q7/8/8/8/8/8/1K2R3 b - - 0 1') }

      it 'returns true' do
        result = defend_king_board.team_can_move?('black')
        expect(result).to be true
      end
    end

    context 'when a piece cant defend king but king can escape' do
      subject(:defend_king_board) { Chess::ChessBoard.new('4k3/q7/8/8/P7/7p/8/1K2R3 b - - 0 1') }

      it 'returns true' do
        result = defend_king_board.team_can_move?('black')
        expect(result).to be true
      end
    end

    context 'when a piece can defend king but king cant move' do
      subject(:defend_king_board) { Chess::ChessBoard.new('4k3/q6R/4N3/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns true' do
        result = defend_king_board.team_can_move?('black')
        expect(result).to be true
      end
    end

    context 'when a piece can defend king and king cant move' do
      subject(:defend_king_board) { Chess::ChessBoard.new('4k3/7R/4N3/8/P7/7p/8/1K6 b - - 0 1') }

      it 'returns true' do
        result = defend_king_board.team_can_move?('black')
        expect(result).to be true
      end
    end
  end

  describe '#find_piece_position' do
    context 'given a piece color and a piece name' do
      subject(:find_piece_board) { Chess::ChessBoard.new }

      it 'returns piece position' do
        piece_position = find_piece_board.find_piece_position('white', 'queen')
        result = Chess::MoveConverter.convert_move(piece_position)
        expect(result).to eq('d1')
      end
    end
  end

  describe '#find_king' do
    context 'when called' do
      subject(:find_king_board) { Chess::ChessBoard.new }
      it 'returns king position' do
        piece_position = find_king_board.find_king('white')
        result = Chess::MoveConverter.convert_move(piece_position)
        expect(result).to eq('e1')
      end
    end
  end
end
