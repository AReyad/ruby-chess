module Chess
  module DefaultPosition
    DEFAULT_POSITIONS = {
      king: { 'black' => [0, 4], 'white' => [7, 4] },
      queen_rook: { 'black' => [0, 0], 'white' => [7, 0] },
      king_rook: { 'black' => [0, 7], 'white' => [7, 7] }
    }.freeze

    def default_piece_position(color, piece)
      DEFAULT_POSITIONS[piece][color]
    end
  end
end
