module Colorize
  module_function

  def background(color, content)
    "\e[48;2;#{color}m#{content}\e[0m"
  end

  def foreground(color, content)
    "\e[38;2;#{color}m #{content} \e[0m"
  end
end
