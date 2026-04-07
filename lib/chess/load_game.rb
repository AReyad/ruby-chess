module Chess
  module LoadGame
    extend Serializer
    extend MenuSelection

    def load_game
      CLI.load_confirmation
      input = gets.chomp.downcase
      return unless %w[yes y ye yea yeah save].include?(input)

      saves = LoadGame.deserialize
      select_from_menu(saves, CLI.load_option_msg)
    end

    def load_file_exists?(file_path)
      File.exist?(file_path) && !File.empty?(file_path)
    end
  end
end
