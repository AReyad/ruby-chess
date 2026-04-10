module Chess
  module Colorize
    module_function

    def background(color, content)
      "\e[48;2;#{color}m#{content}\e[0m"
    end

    def foreground(color, content)
      "\e[38;2;#{color}m #{content} \e[0m"
    end

    def highlight(color, first_value, second_value)
      "\e[38;2;#{color}m#{first_value}#{second_value}\e[0m"
    end

    def colorize_rights(rights, rights_data)
      rights_string = "#{rights}: #{rights_data}"
      return foreground(Palette.color('reddish_brown'), rights_string) if rights_data.nil?

      foreground(Palette.color('green'), rights_string)
    end
  end
end
