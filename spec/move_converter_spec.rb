require_relative '../lib/chess'
describe Chess::MoveConverter do
  describe '#convert_move' do
    context 'when the move is a coord' do
      it 'converts it to algebraic' do
        result = Chess::MoveConverter.convert_move([1, 2])
        second_result = Chess::MoveConverter.convert_move([6, 6])
        expect(result).to eq('c7')
        expect(second_result).to eq('g2')
      end
    end
    context 'when the move is algebraic' do
      it 'converts it to a coord' do
        result = Chess::MoveConverter.convert_move('a1')
        expect(result).to eq([7, 0])
        second_result = Chess::MoveConverter.convert_move('h8')
        expect(second_result).to eq([0, 7])
      end
    end
  end
  describe '#convert_moves' do
    context 'when there are multiple moves' do
      it 'converts all the moves' do
        result = Chess::MoveConverter.convert_moves([[7, 4], [6, 4], [5, 4]])
        expect(result).to eq('e1, e2, e3')
        second_result = Chess::MoveConverter.convert_moves([[1, 4], [2, 2], [3, 7]])
        expect(second_result).to eq('c6, e7, h5')
      end
    end
  end
end
