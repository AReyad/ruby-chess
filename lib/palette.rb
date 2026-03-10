module Palette
  COLORS = {
    'black' => '0;0;0',
    'white' => '255;255;255',
    'red' => '235;204;176',
    'reddish_brown' => '163;82;78',
    'green' => '15;90;32'
  }.freeze

  def self.color(color)
    COLORS[color]
  end
end
