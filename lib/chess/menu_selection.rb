module Chess
  module MenuSelection
    def select_from_menu(options, option_msg)
      keys = options.keys
      keys_length = keys.length
      return keys[0] if keys_length == 1

      display_options(keys, option_msg)
      loop do
        selected_save = gets.chomp
        option = options[keys[selected_save.to_i - 1]]
        next CLI.invalid_option(keys_length) unless valid_option?(option, selected_save)

        return option
      end
    end

    def display_options(options, option_msg)
      options.each_with_index { |key, index| puts "#{index + 1}) #{key}" }
      print option_msg
    end

    def valid_option?(option, input)
      option && input.match?(/\d+/) && input != '0'
    end
  end
end
