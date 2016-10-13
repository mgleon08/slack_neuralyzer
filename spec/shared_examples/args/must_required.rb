shared_examples 'must required' do |params, must|
  it must do
    expect { args.new(params) }.to raise_error(
      SlackNeuralyzer::Errors::RequiredArgumentsError,
      'Must required one of these arguments: ' + must
    )
  end
end
