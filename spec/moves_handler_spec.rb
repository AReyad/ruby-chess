require_relative '../lib/chess'

describe Chess::MovesHandler do
  describe '#simulate_move' do
    context 'when a pawn is moving to an enpassent square' do
      subject(:enpassent_simulation_board) { Chess::ChessBoard.new('r3k2r/8/4p3/2pP4/3K4/8/8/R6R w kq c6 0 1') }
      it 'captures the enpassent' do
        position = Chess::MoveConverter.convert_move('d5')
        destination = Chess::MoveConverter.convert_move('c6')
        enpassent_simulation_board.simulate_move(position, destination)
        result = enpassent_simulation_board.placement_string
        expected_result = 'r3k2r/8/2P1p3/8/3K4/8/8/R6R'
        expect(result).to eq(expected_result)
      end
    end

    context 'when a piece to move is not a pawn' do
      subject(:simulation_board) { Chess::ChessBoard.new('r3k2r/8/4p3/2pP4/3K4/8/8/R6R w kq c6 0 1') }
      it 'simulates a regular move' do
        position = Chess::MoveConverter.convert_move('d4')
        destination = Chess::MoveConverter.convert_move('c5')
        simulation_board.simulate_move(position, destination)
        result = simulation_board.placement_string
        expected_result = 'r3k2r/8/4p3/2KP4/8/8/8/R6R'
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#reset_move' do
    context 'when piece is white pawn and destination to reset is enpassent square' do
      subject(:reset_move_board) { Chess::ChessBoard.new('r3k2r/8/4p3/2pP4/3K4/8/8/R6R w kq c6 0 1') }
      it 'resets captured black pawn' do
        position = Chess::MoveConverter.convert_move('d5')
        destination = Chess::MoveConverter.convert_move('c6')
        destination_value = reset_move_board.at(destination)
        reset_move_board.simulate_move(position, destination)
        result = reset_move_board.placement_string
        expected_result = 'r3k2r/8/2P1p3/8/3K4/8/8/R6R'
        expect(result).to eq(expected_result)
        reset_move_board.reset_move(position, destination, destination_value)
        result = reset_move_board.placement_string
        expected_result = 'r3k2r/8/4p3/2pP4/3K4/8/8/R6R'
        expect(result).to eq(expected_result)
      end
    end

    context 'when piece is black pawn and destination to reset is enpassent square' do
      subject(:reset_move_board) { Chess::ChessBoard.new('r6r/8/8/3k4/2Pp4/4P3/8/R3K2R b - c3 0 1') }
      it 'resets captured white pawn' do
        position = Chess::MoveConverter.convert_move('d4')
        destination = Chess::MoveConverter.convert_move('c3')
        destination_value = reset_move_board.at(destination)
        reset_move_board.simulate_move(position, destination)
        result = reset_move_board.placement_string
        expected_result = 'r6r/8/8/3k4/8/2p1P3/8/R3K2R'
        expect(result).to eq(expected_result)
        reset_move_board.reset_move(position, destination, destination_value)
        result = reset_move_board.placement_string
        expected_result = 'r6r/8/8/3k4/2Pp4/4P3/8/R3K2R'
        expect(result).to eq(expected_result)
      end
    end

    context 'when a normal piece is moving' do
      subject(:reset_move_board) { Chess::ChessBoard.new('r6r/8/8/3k4/2Pp4/4P3/8/R3K2R b - c3 0 1') }
      it 'resets it normally' do
        position = Chess::MoveConverter.convert_move('d5')
        destination = Chess::MoveConverter.convert_move('c4')
        destination_value = reset_move_board.at(destination)
        reset_move_board.simulate_move(position, destination)
        result = reset_move_board.placement_string
        expected_result = 'r6r/8/8/8/2kp4/4P3/8/R3K2R'
        expect(result).to eq(expected_result)
        reset_move_board.reset_move(position, destination, destination_value)
        result = reset_move_board.placement_string
        expected_result = 'r6r/8/8/3k4/2Pp4/4P3/8/R3K2R'
        expect(result).to eq(expected_result)
      end
    end
  end
end
