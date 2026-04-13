require_relative '../../lib/chess'

describe Chess::Castling do
  describe '#rook_position' do
    context 'when a king makes a castling move' do
      subject(:castling_board) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1') }
      it 'returns rook position' do
        king_move = Chess::MoveConverter.convert_move('c1')
        rook_position = castling_board.rook_position(king_move)
        result = Chess::MoveConverter.convert_move(rook_position)
        expect(result).to eq('a1')

        king_move = Chess::MoveConverter.convert_move('g1')
        rook_position = castling_board.rook_position(king_move)
        result = Chess::MoveConverter.convert_move(rook_position)
        expect(result).to eq('h1')
      end
    end
  end

  describe '#rook_destination' do
    context 'when a king makes a castling move' do
      subject(:castling_board) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1') }
      it 'returns rook destination' do
        king_move = Chess::MoveConverter.convert_move('c1')
        rook_destination = castling_board.rook_destination(king_move)
        result = Chess::MoveConverter.convert_move(rook_destination)
        expect(result).to eq('d1')

        king_move = Chess::MoveConverter.convert_move('g1')
        rook_destination = castling_board.rook_destination(king_move)
        result = Chess::MoveConverter.convert_move(rook_destination)
        expect(result).to eq('f1')
      end
    end
  end

  describe '#queen_rights?' do
    context 'when color is white and (Q) is present in fen' do
      subject(:white_queen_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w Q - 0 1') }
      it 'returns true' do
        result = white_queen_rights.queen_rights?('white', white_queen_rights)
        expect(result).to be true
      end
    end

    context 'when color is white and (Q) is absent in fen' do
      subject(:white_queen_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 1') }
      it 'returns false' do
        result = white_queen_rights.queen_rights?('white', white_queen_rights)
        expect(result).to be false
      end
    end

    context 'when color is black and (q) is present in fen' do
      subject(:black_queen_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w q - 0 1') }
      it 'returns true' do
        result = black_queen_rights.queen_rights?('black', black_queen_rights)
        expect(result).to be true
      end
    end

    context 'when color is black and (q) is absent in fen' do
      subject(:black_queen_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 1') }
      it 'returns false' do
        result = black_queen_rights.queen_rights?('black', black_queen_rights)
        expect(result).to be false
      end
    end
  end

  describe '#king_rights?' do
    context 'when color is white and (K) is present in fen' do
      subject(:white_king_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w K - 0 1') }
      it 'returns true' do
        result = white_king_rights.king_rights?('white', white_king_rights)
        expect(result).to be true
      end
    end

    context 'when color is white and (K) is absent in fen' do
      subject(:white_king_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 1') }
      it 'returns false' do
        result = white_king_rights.king_rights?('white', white_king_rights)
        expect(result).to be false
      end
    end

    context 'when color is black and (k) is present in fen' do
      subject(:black_king_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w k - 0 1') }
      it 'returns true' do
        result = black_king_rights.king_rights?('black', black_king_rights)
        expect(result).to be true
      end
    end

    context 'when color is black and (k) is absent in fen' do
      subject(:black_king_rights) { Chess::ChessBoard.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w - - 0 1') }
      it 'returns false' do
        result = black_king_rights.king_rights?('black', black_king_rights)
        expect(result).to be false
      end
    end
  end

  describe '#default_king_position' do
    context 'when color is white' do
      subject(:white_king_board) { Chess::ChessBoard.new }
      it 'returns default white king position' do
        result = Chess::MoveConverter.convert_move(white_king_board.default_king_position('white'))
        expect(result).to eq 'e1'
      end
    end

    context 'when color is black' do
      subject(:black_king_board) { Chess::ChessBoard.new }
      it 'returns default black king position' do
        result = Chess::MoveConverter.convert_move(black_king_board.default_king_position('black'))
        expect(result).to eq 'e8'
      end
    end
  end

  describe '#queen_rook_reachable?' do
    context 'when there are piece between king and queens rook' do
      subject(:rook_unreachable_board) { Chess::ChessBoard.new }
      it 'returns false' do
        king_position = Chess::MoveConverter.convert_move('e1')
        result = rook_unreachable_board.queen_rook_reachable?(rook_unreachable_board, king_position)
        expect(result).to be false
      end
    end

    context 'when there are no piece between king and queens rook' do
      subject(:rook_reachable_board) { Chess::ChessBoard.new('1p1k1n2/8/8/8/8/8/8/R3K3 w Q - 0 1') }
      it 'returns true' do
        king_position = Chess::MoveConverter.convert_move('e1')
        result = rook_reachable_board.queen_rook_reachable?(rook_reachable_board, king_position)
        expect(result).to be true
      end
    end
  end

  describe '#king_rook_reachable?' do
    context 'when there are piece between king and kings rook' do
      subject(:rook_unreachable_board) { Chess::ChessBoard.new }
      it 'returns false' do
        king_position = Chess::MoveConverter.convert_move('e1')
        result = rook_unreachable_board.king_rook_reachable?(rook_unreachable_board, king_position)
        expect(result).to be false
      end
    end

    context 'when there are no piece between king and kings rook' do
      subject(:rook_reachable_board) { Chess::ChessBoard.new('1p1k1n2/8/8/8/8/8/8/4K2R w K - 0 1') }
      it 'returns true' do
        king_position = Chess::MoveConverter.convert_move('e1')
        result = rook_reachable_board.king_rook_reachable?(rook_reachable_board, king_position)
        expect(result).to be true
      end
    end
  end

  describe '#castling_moves' do
    context 'when white king side castling is possible' do
      subject(:king_sidecastling_board) { Chess::ChessBoard.new('1p1k1n2/8/8/8/8/8/8/4K2R w K - 0 1') }
      it 'returns white king side castling move coord' do
        king_position = Chess::MoveConverter.convert_move('e1')
        castling_move = king_sidecastling_board.castling_moves('white', king_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_move(castling_move[0])
        expect(result).to eq('g1')
      end
    end

    context 'when white queen side castling is possible' do
      subject(:queen_sidecastling_board) { Chess::ChessBoard.new('1p1k1n2/8/8/8/8/8/8/R3K3 w Q - 0 1') }
      it 'returns white queen side castling move coord' do
        king_position = Chess::MoveConverter.convert_move('e1')
        castling_move = queen_sidecastling_board.castling_moves('white', queen_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_move(castling_move[0])
        expect(result).to eq('c1')
      end
    end

    context 'when white side castling is possible on both sides' do
      subject(:both_sidecastling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'returns two coords' do
        king_position = Chess::MoveConverter.convert_move('e1')
        castling_move = both_sidecastling_board.castling_moves('white', both_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_moves(castling_move)
        expect(result).to eq('c1, g1')
      end
    end

    context 'when black king side castling is possible' do
      subject(:king_sidecastling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K3 w Qk - 0 1') }
      it 'returns black king side castling move coord' do
        king_position = Chess::MoveConverter.convert_move('e8')
        castling_move = king_sidecastling_board.castling_moves('black', king_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_move(castling_move[0])
        expect(result).to eq('g8')
      end
    end

    context 'when black queen side castling is possible' do
      subject(:queen_sidecastling_board) { Chess::ChessBoard.new('r3k3/8/8/8/8/8/8/R3K3 w Qq - 0 1') }
      it 'returns black queen side castling move coord' do
        king_position = Chess::MoveConverter.convert_move('e8')
        castling_move = queen_sidecastling_board.castling_moves('black', queen_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_move(castling_move[0])
        expect(result).to eq('c8')
      end
    end

    context 'when black side castling is possible on both sides' do
      subject(:both_sidecastling_board) { Chess::ChessBoard.new('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1') }
      it 'returns two coords' do
        king_position = Chess::MoveConverter.convert_move('e8')
        castling_move = both_sidecastling_board.castling_moves('black', both_sidecastling_board, king_position)
        result = Chess::MoveConverter.convert_moves(castling_move)
        expect(result).to eq('c8, g8')
      end
    end
  end

  describe '#castlable?' do
    subject(:castlable_board) { Chess::ChessBoard.new('r3k3/8/8/8/8/8/8/R3K3 w Qq - 0 1') }

    context 'when either side is castlable' do
      it 'returns true' do
        king_position = Chess::MoveConverter.convert_move('e8')
        result = castlable_board.castlable?('black', castlable_board, king_position)
        expect(result).to be true
      end
    end

    context 'when neither side is castlable' do
      subject(:uncastlable_board) { Chess::ChessBoard.new('r3k3/8/8/8/8/8/8/R3K3 w - - 0 1') }
      it 'returns false' do
        king_position = Chess::MoveConverter.convert_move('e8')
        result = uncastlable_board.castlable?('black', uncastlable_board, king_position)
        expect(result).to be false
        king_position = Chess::MoveConverter.convert_move('e1')
        result = uncastlable_board.castlable?('white', uncastlable_board, king_position)
        expect(result).to be false
      end
    end
  end

  describe '#both_sides_castlable?' do
    context 'when one side is castlable' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'returns false' do
        king_position = Chess::MoveConverter.convert_move('e8')
        result = castling_board.both_sides_castlable?('black', castling_board, king_position)
        expect(result).to be false
      end
    end

    context 'when both sides are castlable' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'returns true' do
        king_position = Chess::MoveConverter.convert_move('e1')
        result = castling_board.both_sides_castlable?('white', castling_board, king_position)
        expect(result).to be true
      end
    end
  end

  describe '#castling_move?' do
    context 'when white king is on default position and is moving to c1 or g1' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'is a castling move' do
        position = Chess::MoveConverter.convert_move('e1')
        destination = Chess::MoveConverter.convert_move('g1')
        result = castling_board.castling_move?('white', position, destination)
        expect(result).to be true

        position = Chess::MoveConverter.convert_move('e1')
        destination = Chess::MoveConverter.convert_move('c1')
        result = castling_board.castling_move?('white', position, destination)
        expect(result).to be true
      end
    end

    context 'when black king is on default position and is moving to c1 or g1' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'is a castling move' do
        position = Chess::MoveConverter.convert_move('e8')
        destination = Chess::MoveConverter.convert_move('g8')
        result = castling_board.castling_move?('black', position, destination)
        expect(result).to be true

        position = Chess::MoveConverter.convert_move('e8')
        destination = Chess::MoveConverter.convert_move('c8')
        result = castling_board.castling_move?('black', position, destination)
        expect(result).to be true
      end
    end

    context 'when white king is on default position and is moving to d1 or f1' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'is not a castling move' do
        position = Chess::MoveConverter.convert_move('e1')
        destination = Chess::MoveConverter.convert_move('d1')
        result = castling_board.castling_move?('white', position, destination)
        expect(result).to be false

        position = Chess::MoveConverter.convert_move('e1')
        destination = Chess::MoveConverter.convert_move('f1')
        result = castling_board.castling_move?('white', position, destination)
        expect(result).to be false
      end
    end

    context 'when black king is on default position and is moving to d1 or f1' do
      subject(:castling_board) { Chess::ChessBoard.new('4k2r/8/8/8/8/8/8/R3K2R w KQk - 0 1') }
      it 'is not a castling move' do
        position = Chess::MoveConverter.convert_move('e8')
        destination = Chess::MoveConverter.convert_move('d8')
        result = castling_board.castling_move?('black', position, destination)
        expect(result).to be false

        position = Chess::MoveConverter.convert_move('e8')
        destination = Chess::MoveConverter.convert_move('f8')
        result = castling_board.castling_move?('black', position, destination)
        expect(result).to be false
      end
    end
  end
end
