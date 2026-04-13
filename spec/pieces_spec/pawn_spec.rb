require_relative '../../lib/chess'
describe Chess::Pawn do
  describe '#safe_moves' do
    context 'when a pawn has not moved from its default position' do
      subject(:board) { Chess::ChessBoard.new }
      it 'can move one step or two steps' do
        pawn_position = Chess::MoveConverter.convert_move('a2')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'a3, a4'
        expect(result).to eq expected_moves
      end
    end

    context 'when a pawn has moved from its default position' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/4P3/PPPP1PPP/RNBQKBNR w KQkq - 0 1') }
      it 'can move one step only' do
        pawn_position = Chess::MoveConverter.convert_move('e3')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e4'
        expect(result).to eq expected_moves
      end
    end

    context 'when a pawn is black' do
      subject(:board) { Chess::ChessBoard.new }
      it 'moves towards the bottom' do
        pawn_position = Chess::MoveConverter.convert_move('e7')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e5, e6'
        expect(result).to eq expected_moves
      end
    end

    context 'when a pawn is white' do
      subject(:board) { Chess::ChessBoard.new }
      it 'moves towards the top' do
        pawn_position = Chess::MoveConverter.convert_move('e2')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e3, e4'
        expect(result).to eq expected_moves
      end
    end

    context 'when a pawn is blocked by a piece' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppp1ppp/8/8/8/4p3/PPPPPPPP/RNBQKBNR w KQkq - 0 4') }
      it 'cannot move forward' do
        pawn_position = Chess::MoveConverter.convert_move('e2')
        pawn = board.at(pawn_position)
        result = pawn.safe_moves(pawn_position, board)
        expected_moves = []
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnbqkbnr/pppp1ppp/8/8/8/4p3/PPPPPPPP/RNBQKBNR w KQkq - 0 4')
      end
    end

    context 'when a pawn is blocked by a piece and is able to capture a piece' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/ppp2ppp/8/3pp3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 3') }
      it 'can move to the capture position' do
        pawn_position = Chess::MoveConverter.convert_move('e4')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'd5'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnbqkbnr/ppp2ppp/8/3pp3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 3')
      end
    end

    context 'when a pawn has two capturable pieces' do
      subject(:board) { Chess::ChessBoard.new('rnbqkbnr/pppp1ppp/2P5/8/8/8/PP1PPPPP/RNBQKBNR w KQkq - 0 4') }
      it 'can capture either one' do
        pawn_position = Chess::MoveConverter.convert_move('c6')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'b7, d7'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnbqkbnr/pppp1ppp/2P5/8/8/8/PP1PPPPP/RNBQKBNR w KQkq - 0 4')
      end
    end

    context 'when a move can put the king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/ppp1qppp/3p4/4P3/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1') }
      it 'cannot make that move' do
        pawn_position = Chess::MoveConverter.convert_move('e5')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e6'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnb1kbnr/ppp1qppp/3p4/4P3/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1')
      end
    end

    context 'when an enpassent move can put the king in check' do
      subject(:board) { Chess::ChessBoard.new('rnb1kbnr/ppp1qppp/8/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 1') }
      it 'cannot make that move' do
        pawn_position = Chess::MoveConverter.convert_move('e5')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'e6'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('rnb1kbnr/ppp1qppp/8/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 1')
      end
    end

    context 'when an enpassent move can make the king escape check' do
      subject(:board) { Chess::ChessBoard.new('4k3/8/8/3pP3/4K3/8/8/8 w - d6 0 1') }
      it 'can make that move' do
        pawn_position = Chess::MoveConverter.convert_move('e5')
        pawn = board.at(pawn_position)
        moves = pawn.safe_moves(pawn_position, board)
        result = Chess::MoveConverter.convert_moves(moves)
        expected_moves = 'd6'
        fen_string = board.fen_string
        expect(result).to eq expected_moves
        expect(fen_string).to eq('4k3/8/8/3pP3/4K3/8/8/8 w - d6 0 1')
      end
    end
  end
end
