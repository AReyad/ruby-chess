module Chess
  module Promotion
    WHITE_LAST_ROW = 0
    BLACK_LAST_ROW = 7

    def promotable?(position, color)
      return unless at(position).pawn?
      return black_promotable?(position) if color == 'black'

      white_promotable?(position)
    end

    def black_promotable?(position)
      position[0] == BLACK_LAST_ROW
    end

    def white_promotable?(position)
      position[0] == WHITE_LAST_ROW
    end

    def promotions(color)
      { 'Queen' => Queen.new(color), 'Rook' => Rook.new(color), 'Knight' => Knight.new(color),
        'Bishop' => Bishop.new(color) }
    end
  end
end
