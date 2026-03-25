module Chess
  module Selection
    def selection
      loop do
        piece_position = select_piece(current_player)
        return piece_position if %w[save exit].include?(piece_position)

        moves = board.at(piece_position).safe_moves(piece_position, board)
        board.highlight_display(moves)
        destination = select_destination(current_player, moves)
        next if destination == 'back'

        return { position: piece_position, destination: destination }
      end
    end

    def select_piece(player)
      board.display
      if board.king_in_check?(player.color)
        CLI.king_in_check
        return incheck_piece_selection(player)
      end

      CLI.turn(player)
      regular_piece_selection(player)
    end

    def regular_piece_selection(player)
      loop do
        input = player.selection until input
        return input if %w[save exit].include?(input) || board.selectable?(input, player.color)

        CLI.invalid_selection(player, board.at(input))
      end
    end

    def incheck_piece_selection(player)
      loop do
        input = player.selection until input
        return input if input == 'save' || board.in_check_selectable?(input, player.color)

        CLI.invalid_incheck_selection(player, board.at(input))
      end
    end

    def select_destination(player, moves)
      loop do
        CLI.post_selection(moves)
        input = player.destination until input

        return input if board.valid_move?(moves, input) || input == 'back'
      end
    end
  end
end
