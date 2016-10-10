require 'spec_helper'

describe SlackNeuralyzer::Colorizable do
  include described_class

  it '#light_green' do
    text = light_green('clean your slack')
    expect(text).to eq("\e[0;92;49mclean your slack\e[0m")
  end

  it '#light_cyan' do
    text = light_cyan('clean your slack')
    expect(text).to eq("\e[0;96;49mclean your slack\e[0m")
  end

  it '#light_red' do
    text = light_red('clean your slack')
    expect(text).to eq("\e[0;91;49mclean your slack\e[0m")
  end

  it '#light_blue' do
    text = light_blue('clean your slack')
    expect(text).to eq("\e[0;94;49mclean your slack\e[0m")
  end

  it '#light_yellow' do
    text = light_yellow('clean your slack')
    expect(text).to eq("\e[0;93;49mclean your slack\e[0m")
  end

  it '#light_magenta' do
    text = light_magenta('clean your slack')
    expect(text).to eq("\e[0;95;49mclean your slack\e[0m")
  end
end
