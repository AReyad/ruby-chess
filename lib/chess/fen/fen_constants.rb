module Chess
  module FenConstants
    INITIAL_FEN = { placement: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
                    turn: 'w',
                    castling: 'KQkq',
                    enpassent: '-',
                    halfmove: 0,
                    fullmove: 1,
                    threefold: { w: [], b: [] } }

    INITIAL_PIECE_PLACEMENT = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'.freeze
    INITIAL_PIECE_PLACEMENT = '8/P7/8/8/8/8/8/8'.freeze

    PIECES_NOTATION = { 'n' => { name: Chess::Knight, color: 'black' }, 'r' => { name: Chess::Rook, color: 'black' },
                        'b' => { name: Chess::Bishop, color: 'black' }, 'q' => { name: Chess::Queen, color: 'black' },
                        'k' => { name: Chess::King, color: 'black' },   'p' => { name: Chess::Pawn, color: 'black' },
                        'N' => { name: Chess::Knight, color: 'white' }, 'R' => { name: Chess::Rook, color: 'white' },
                        'B' => { name: Chess::Bishop, color: 'white' }, 'Q' => { name: Chess::Queen, color: 'white' },
                        'K' => { name: Chess::King, color: 'white' },   'P' => { name: Chess::Pawn, color: 'white' } }.freeze
  end
end
