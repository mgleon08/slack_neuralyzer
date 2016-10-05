require 'spec_helper'

describe SlackNeuralyzer::Helper do
  include described_class

  it '#parse_to_ts' do
    parse_to_ts('20160101', '20161212')
    expect(start_time).to eq(1451577600.0)
    expect(end_time).to eq(1481472000.0)
  end

  it '#parse_to_date' do
    time = parse_to_date(1451577600.0)
    expect(time).to eq('2016-01-01 00:00')
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
