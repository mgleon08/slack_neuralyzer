module SlackNeuralyzer
  module Colorizable
    [
      :light_green,
      :light_cyan,
      :light_red,
      :light_blue,
      :light_yellow,
      :light_magenta
    ].each do |color|
      define_method(color) do |text|
        text.to_s.public_send(color)
      end
    end
  end
end
