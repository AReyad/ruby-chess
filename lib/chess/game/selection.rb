module Chess
  module Selection
    def selection
      loop do
        piece_position = select_piece(current_player)
        return piece_position if %w[save exit].include?(piece_position)

        moves = board.at(piece_position).safe_moves(piece_position, board)
        board.display(moves)
        destination = select_destination(current_player, moves)
        next if destination == 'back'

        return { position: piece_position, destination: destination }
      end
    end

    def select_piece(player)
      board.display
      if board.king_in_check?(player.color)
        CLI.king_in_check
        return piece_selection(player, true)
      end

      CLI.turn(player)
      piece_selection(player, false)
    end

    def piece_selection(player, in_check)
      loop do
        input = player.selection until input

        next invalid_piece_selection(player, input, in_check) unless valid_selection?(player, input)

        return input
      end
    end

    def invalid_piece_selection(player, input, in_check)
      piece = board.at(input)
      CLI.invalid_selection(player, piece) unless in_check
      CLI.invalid_incheck_selection(player, piece) if in_check
    end

    def valid_selection?(player, input)
      %w[save exit].include?(input) || board.selectable?(input, player.color)
    end

    def select_destination(player, moves)
      loop do
        CLI.post_selection(moves)
        input = player.destination until input

        return input if board.valid_move?(moves, input) || input == 'back'

        CLI.invalid_destination(input)
      end
    end
  end
end
