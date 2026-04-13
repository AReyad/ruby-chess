require_relative '../lib/chess'

describe Chess::Fen do
  describe '#create_fen_string' do
    context 'when data is a hash' do
      subject(:fen_hash_data) { described_class.new }
      it 'converts it to a fen string' do
        result = fen_hash_data.create_fen_string
        expected_result = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        expect(result).to eq expected_result
      end
    end
  end

  describe '#create_fen_hash' do
    context 'when given a fen string' do
      subject(:fen_to_hash) { described_class.new }
      it 'converts it to a hash' do
        fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        result = fen_to_hash.create_fen_hash(fen_string)
        expected_result = { 'placement' => 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
                            'turn' => 'w',
                            'castling' => 'KQkq',
                            'enpassent' => '-',
                            'halfmove' => 0,
                            'fullmove' => 1 }
        expect(result).to eq expected_result
      end
    end
  end

  describe '#create_fen_hash' do
    context 'when given a fen string' do
      subject(:fen_to_hash) { described_class.new }
      it 'converts it to a hash' do
        fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
        result = fen_to_hash.create_fen_hash(fen_string)
        expected_result = { 'placement' => 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
                            'turn' => 'w',
                            'castling' => 'KQkq',
                            'enpassent' => '-',
                            'halfmove' => 0,
                            'fullmove' => 1 }
        expect(result).to eq expected_result
      end
    end
  end

  describe '#castling_rights' do
    context 'when called' do
      subject(:fen_castling) { described_class.new }
      it 'returns castling rights' do
        result = fen_castling.castling_rights
        expected_result = 'KQkq'
        expect(result).to eq expected_result
      end
    end
  end

  describe '#enpassent' do
    context 'when there is no enpassent' do
      subject(:fen_enpassent) { described_class.new }
      it 'returns nil' do
        result = fen_enpassent.enpassent
        expected_result = nil
        expect(result).to eq expected_result
      end
    end

    context 'when there is enpassent' do
      subject(:fen_enpassent) { described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq e3 0 1') }
      it 'returns the enpassent position' do
        result = fen_enpassent.enpassent
        expected_result = 'e3'
        expect(result).to eq expected_result
      end
    end
  end

  describe '#repeated_regular_moves?' do
    context 'when halfmove is 100 and fullmove is over 49' do
      subject(:fen_repeated_moves) do
        described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 100 50')
      end

      it 'returns true' do
        result = fen_repeated_moves.repeated_regular_moves?
        expect(result).to be true
      end
    end

    context 'when halfmove is not 100 and fullmove is over 49' do
      subject(:fen_not_repeated_moves) do
        described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 101 51')
      end

      it 'returns false' do
        result = fen_not_repeated_moves.repeated_regular_moves?
        expect(result).to be false
      end
    end
  end

  describe '#repeated_states?' do
    context 'when a state is repeated 3 times' do
      subject(:fen_threefold) do
        described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                            [
                              'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                              'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -'
                            ])
      end

      it 'returns true' do
        result = fen_threefold.repeated_states?
        expect(result).to be true
      end
    end

    context 'when a state is repeated 5 times' do
      subject(:fen_fivefold) do
        described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                            [
                              'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                              'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                              'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -', 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -'
                            ])
      end
      it 'returns true' do
        result = fen_fivefold.repeated_states?(5)
        expect(result).to be true
      end
    end

    context 'when a state is repeated 4 times' do
      subject(:fen_not_threefold) do
        described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                            ['rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                             'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                             'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
                             'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -'])
      end
      it 'returns false' do
        fen_not_threefold.instance_variable_set(:@states, [])
        result = fen_not_threefold.repeated_states?
        expect(result).to be false
      end
    end
  end

  describe '#turn' do
    context 'when turn is black' do
      subject(:fen_turn) { described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq -') }
      it 'returns black' do
        result = fen_turn.turn
        expect(result).to eq('black')
      end
    end

    context 'when turn is white' do
      subject(:fen_turn) { described_class.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -') }
      it 'returns white' do
        result = fen_turn.turn
        expect(result).to eq('white')
      end
    end
  end

  describe '#update_enpassent' do
    context 'when a pawn moves 2 steps' do
      subject(:enpassent_board) { Chess::ChessBoard.new }
      subject(:enpassent_fen) { described_class.new }
      it 'updates enpassent' do
        pawn_position = Chess::MoveConverter.convert_move('b2')
        pawn_destination = Chess::MoveConverter.convert_move('b4')
        enpassent_fen.update_enpassent(pawn_position, pawn_destination, enpassent_board)
        result = enpassent_fen.enpassent
        expect(result).to eq('b3')
      end
    end

    context 'when a pawn moves 1 step' do
      subject(:enpassent_board) { Chess::ChessBoard.new }
      subject(:enpassent_fen) { described_class.new }
      it 'does not update enpassent' do
        pawn_position = Chess::MoveConverter.convert_move('b2')
        pawn_destination = Chess::MoveConverter.convert_move('b3')
        enpassent_fen.update_enpassent(pawn_position, pawn_destination, enpassent_board)
        result = enpassent_fen.enpassent
        expect(result).to be nil
      end
    end
  end

  describe '#update_turn' do
    subject(:turn_board) { Chess::ChessBoard.new }
    subject(:turn_fen) { described_class.new }

    context 'when turn is white' do
      it 'updates turn to black' do
        turn_fen.update_turn
        result = turn_fen.turn
        expect(result).to eq('black')
      end
    end

    context 'when turn is black' do
      it 'updates turn to white' do
        turn_fen.update_turn
        result = turn_fen.turn
        expect(result).to eq('white')
      end
    end
  end

  describe '#update_halfmove' do
    subject(:halfmove_board) { Chess::ChessBoard.new }
    subject(:halfmove_fen) { described_class.new }
    context 'when a piece to move is not a pawn' do
      it 'increases halfmove by 1' do
        knight_position = Chess::MoveConverter.convert_move('b1')
        knight_destination = Chess::MoveConverter.convert_move('a3')
        halfmove_fen.update_halfmove(knight_position, knight_destination, halfmove_board)
        data = halfmove_fen.instance_variable_get(:@data)
        result = data['halfmove']
        expect(result).to be 1
      end
    end

    context 'when a piece to move is a pawn' do
      it 'resets halfmove to 0' do
        pawn_position = Chess::MoveConverter.convert_move('b2')
        pawn_destination = Chess::MoveConverter.convert_move('b3')
        halfmove_fen.update_halfmove(pawn_position, pawn_destination, halfmove_board)
        data = halfmove_fen.instance_variable_get(:@data)
        result = data['halfmove']
        expect(result).to be 0
      end
    end

    context 'when a destination is an opponent piece' do
      subject(:halfmove_reset_board) { Chess::ChessBoard.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      subject(:halfmove_reset_fen) do
        described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 223 121')
      end
      it 'resets halfmove to 0' do
        knight_position = Chess::MoveConverter.convert_move('b1')
        knight_destination = Chess::MoveConverter.convert_move('a3')
        halfmove_reset_fen.update_halfmove(knight_position, knight_destination, halfmove_reset_board)
        data = halfmove_reset_fen.instance_variable_get(:@data)
        result = data['halfmove']
        expect(result).to be 0
      end
    end
  end

  describe '#increase_fullmove' do
    subject(:fullmove_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR b KQkq - 0 1') }
    context 'when it is black to move' do
      it 'increases fullmove by 1' do
        fullmove_fen.increase_fullmove
        data = fullmove_fen.instance_variable_get(:@data)
        result = data['fullmove']
        fullmove_fen.update_turn
        expect(result).to be 2
      end
    end

    context 'when it is white to move' do
      it 'does not increase fullmove' do
        fullmove_fen.increase_fullmove
        data = fullmove_fen.instance_variable_get(:@data)
        result = data['fullmove']
        expect(result).to be 2
      end
    end
  end

  describe '#update_castling_rights' do
    subject(:castling_board) { Chess::ChessBoard.new }
    context 'when a piece to move is a queen side white rook' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates queen side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('a1')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('Kkq')
      end
    end

    context 'when a piece to move is a king side white rook' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates king side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('h1')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('Qkq')
      end
    end

    context 'when a piece to move is white king' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates king side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('e1')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('kq')
      end
    end

    context 'when a piece to move is a queen side black rook' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates queen side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('a8')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('KQk')
      end
    end

    context 'when a piece to move is a king side black rook' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates king side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('h8')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('KQq')
      end
    end

    context 'when a piece to move is white king' do
      subject(:castling_fen) { described_class.new('rnbqkbnr/pp1ppppp/8/8/8/p7/PPPPPPPP/RNBQKBNR w KQkq - 0 1') }
      it 'updates king side castling rights' do
        rook_position = Chess::MoveConverter.convert_move('e8')
        castling_fen.update_castling_rights(rook_position, castling_board)
        result = castling_fen.castling_rights
        expect(result).to eq('KQ')
      end
    end
  end

  describe '#update_imported_castling' do
    context 'when fen string has kingside castling but rook is not on default position' do
      let(:fen_string) { 'r3k1r1/8/8/8/8/8/8/R3K1R1 w KQkq - 0 1' }
      subject(:update_castling_board) { Chess::ChessBoard.new(fen_string) }
      subject(:fen) { described_class.new(fen_string) }

      it 'updates white kingside castling' do
        fen.update_imported_castling(update_castling_board)
        result = fen.create_fen_string
        expected_result = 'r3k1r1/8/8/8/8/8/8/R3K1R1 w Qq - 0 1'
        expect(result).to eq(expected_result)
      end
    end

    context 'when fen string has queenside castling but rook is not on default position' do
      let(:fen_string) { '1r2k2r/8/8/8/8/8/8/1R2K2R w KQkq - 0 1' }
      subject(:update_castling_board) { Chess::ChessBoard.new(fen_string) }
      subject(:fen) { described_class.new(fen_string) }

      it 'updates white queenside castling' do
        fen.update_imported_castling(update_castling_board)
        result = fen.create_fen_string
        expected_result = '1r2k2r/8/8/8/8/8/8/1R2K2R w Kk - 0 1'
        expect(result).to eq(expected_result)
      end
    end

    context 'when fen string has castling rights but white king is not on default position' do
      let(:fen_string) { 'r3k2r/8/8/8/8/8/4K3/R6R w KQkq - 0 1' }
      subject(:update_castling_board) { Chess::ChessBoard.new(fen_string) }
      subject(:fen) { described_class.new(fen_string) }

      it 'updates white king castling rights' do
        fen.update_imported_castling(update_castling_board)
        result = fen.create_fen_string
        expected_result = 'r3k2r/8/8/8/8/8/4K3/R6R w kq - 0 1'
        expect(result).to eq(expected_result)
      end
    end

    context 'when fen string has castling rights but black king is not on default position' do
      let(:fen_string) { 'r6r/4k3/8/8/8/8/8/R3K2R w KQkq - 0 1' }
      subject(:update_castling_board) { Chess::ChessBoard.new(fen_string) }
      subject(:fen) { described_class.new(fen_string) }

      it 'updates black king castling rights' do
        fen.update_imported_castling(update_castling_board)
        result = fen.create_fen_string
        expected_result = 'r6r/4k3/8/8/8/8/8/R3K2R w KQ - 0 1'
        expect(result).to eq(expected_result)
      end
    end

    context 'when fen string has castling rights and both sides can castle' do
      let(:fen_string) { 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1' }
      subject(:update_castling_board) { Chess::ChessBoard.new(fen_string) }
      subject(:fen) { described_class.new(fen_string) }

      it 'does not update castling rights' do
        fen.update_imported_castling(update_castling_board)
        result = fen.create_fen_string
        expected_result = 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1'
        expect(result).to eq(expected_result)
      end
    end
  end
end
