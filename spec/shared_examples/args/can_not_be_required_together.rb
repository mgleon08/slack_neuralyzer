shared_examples 'can not be required together' do |params, not_together|
  it not_together do
    expect { args.new(params) }.to raise_error(
      SlackNeuralyzer::Errors::MutuallyExclusiveArgumentsError,
      'These arguments can not be required together: ' + not_together
    )
  end
end
