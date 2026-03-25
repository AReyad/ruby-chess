module Chess
  class Player
    attr_reader :color, :name

    def initialize(name, color)
      @name = name
      @color = color
    end

    def selection
      player_input = gets.chomp.downcase
      return player_input if %w[save exit].include?(player_input)
      return CLI.invalid_input(player_input) unless valid_input?(player_input)

      MoveConverter.convert_move(player_input)
    end

    def destination
      player_input = gets.chomp.downcase
      return player_input if player_input == 'back'
      return CLI.invalid_input(player_input) unless valid_input?(player_input)

      MoveConverter.convert_move(player_input)
    end

    def valid_input?(input)
      input.length == 2 && algebraic_input?(input)
    end

    def algebraic_input?(input)
      splitted_input = input.split('')
      splitted_input[0].match?(/[a-h]/) && splitted_input[1].match?(/[1-8]/)
    end
  end
end
