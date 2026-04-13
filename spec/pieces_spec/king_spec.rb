require_relative '../../lib/chess'

describe Chess::King do
  describe '#safe_moves' do
    context 'When the king is surrounded by his own pieces' do
      subject(:board) { Chess::ChessBoard.new }
      it 'wont have any moves' do
        king_pos = Chess::MoveConverter.convert_move('e8')
        king = board.at(king_pos)
        moves = king.safe_moves(king_pos, board)
        result = moves
        expected_moves = []
        expect(result).to eq expected_moves
      end
    end

    context 'When the king is surrounded by his own pieces' do
      subject(:board) { Chess::ChessBoard.new }
      it 'wont have any moves' do
        king_pos = Chess::MoveConverter.convert_move('e8')
        king = board.at(king_pos)
        moves = king.safe_moves(king_pos, board)
        result = moves
        expected_moves = []
        expect(result).to eq expected_moves
      end
    end

    context 'When the king has is blocked by an opponent piece' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppp1ppp/8/8/4p3/4K3/PPPPPPPP/RNBQ1BNR w kq - 0 1') }
      it 'can capture it' do
        king_pos = Chess::MoveConverter.convert_move('e3')
        king = board.at(king_pos)
        moves = king.safe_moves(king_pos, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'd4, e4, f4'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnbqkbnr/pppp1ppp/8/8/4p3/4K3/PPPPPPPP/RNBQ1BNR w kq - 0 1')
      end
    end

    context 'When a move can put the king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/pppp1ppp/8/8/7q/2P4K/PP1PP2P/RNBQB1NR w kq - 0 1') }
      it 'excludes the move from the move set' do
        king_pos = Chess::MoveConverter.convert_move('h3')
        king = board.at(king_pos)
        moves = king.safe_moves(king_pos, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'g2, h4'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnb1kbnr/pppp1ppp/8/8/7q/2P4K/PP1PP2P/RNBQB1NR w kq - 0 1')
      end
    end

    context 'When a white king can castle king rook' do
      subject(:castling_board) { Chess::ChessBoard.new('N3k2r/8/8/8/8/8/8/n1B1K2R w Kk - 0 1') }
      it 'includes the move in the move set' do
        king_pos = Chess::MoveConverter.convert_move('e1')
        king = castling_board.at(king_pos)
        moves = king.safe_moves(king_pos, castling_board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'd1, d2, e2, f1, f2, g1'
        fen_string = castling_board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('N3k2r/8/8/8/8/8/8/n1B1K2R w Kk - 0 1')
      end
    end

    context 'When a black king can castle both sides' do
      subject(:castling_board) { Chess::ChessBoard.new('r3k2r/8/8/8/8/8/8/n1B1K2R w Kkq - 0 1') }
      it 'includes the moves in the move set' do
        king_pos = Chess::MoveConverter.convert_move('e8')
        king = castling_board.at(king_pos)
        moves = king.safe_moves(king_pos, castling_board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'c8, d7, d8, e7, f7, f8, g8'
        fen_string = castling_board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('r3k2r/8/8/8/8/8/8/n1B1K2R w Kkq - 0 1')
      end
    end
  end
end
