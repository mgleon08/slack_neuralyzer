require 'spec_helper'

describe SlackNeuralyzer::Helper do
  include described_class

  it '#parse_to_ts' do
    parse_to_ts('20160101', '20161212')
    expect(start_time).to eq(Time.parse('20160101').to_f)
    expect(end_time).to eq(Time.parse('20161212').to_f)
  end

  it '#parse_to_date' do
    time = parse_to_date(1_451_577_600.0)
    expect(time).to eq(Time.at('1_451_577_600'.to_f).strftime('%Y-%m-%d %H:%M'))
  end

  it '#reset_counter' do
    reset_counter
    expect(counter).to eq(0)
  end

  it '#increase_counter' do
    reset_counter
    increase_counter
    expect(counter).to eq(1)
  end
end
