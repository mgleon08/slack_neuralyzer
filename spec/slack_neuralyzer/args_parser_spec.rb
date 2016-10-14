require 'spec_helper'

describe SlackNeuralyzer::ArgsParser do
  subject(:args) { described_class }

  context 'when type arguments' do
    it 'should get right with short args' do
      allow_any_instance_of(args).to receive(:validates_required_args)
      allow_any_instance_of(args).to receive(:validates_mutex_args)
      parsms = ['-t', '123', '-m', '-f', 'all', '-C', 'channel', '-D', 'direct',
                '-G', 'group', '-M', 'mpdirect', '-u', 'user', '-b', 'bot',
                '-A', '20160101', '-B', '20161212', '-e', '-l', '-r', '0.5', '-R', 'delete']

      arg = args.new(parsms)
      expect(arg.token).to    eq '123'
      expect(arg.show).to     eq nil
      expect(arg.message).to  eq true
      expect(arg.file).to     eq 'all'
      expect(arg.channel).to  eq 'channel'
      expect(arg.direct).to   eq 'direct'
      expect(arg.group).to    eq 'group'
      expect(arg.mpdirect).to eq 'mpdirect'
      expect(arg.user).to     eq 'user'
      expect(arg.bot).to      eq 'bot'
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
      expect(arg.regex).to    eq 'delete'
    end

    it 'should get right with long args' do
      allow_any_instance_of(args).to receive(:validates_required_args)
      allow_any_instance_of(args).to receive(:validates_mutex_args)
      parsms = ['--token', '123', '--message', '--file', 'all',
                '--channel', 'channel', '--direct', 'direct', '--group',
                'group', '--mpdirect', 'mpdirect', '--user', 'user',
                '--bot', 'bot', '--after', '20160101', '--before',
                '20161212', '--execute', '--log', '--rate', '0.5', '--regex', 'delete']

      arg = args.new(parsms)
      expect(arg.token).to    eq '123'
      expect(arg.show).to     eq nil
      expect(arg.message).to  eq true
      expect(arg.file).to     eq 'all'
      expect(arg.channel).to  eq 'channel'
      expect(arg.direct).to   eq 'direct'
      expect(arg.group).to    eq 'group'
      expect(arg.mpdirect).to eq 'mpdirect'
      expect(arg.user).to     eq 'user'
      expect(arg.bot).to      eq 'bot'
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
      expect(arg.regex).to    eq 'delete'
    end
  end

  context '#rate_limit' do
    it 'default' do
      parsms = ['-t', '123', '-m', '-C', 'channel', '-u',
                'leon']
      arg = args.new(parsms)
      expect(arg.rate_limit).to eq(0.1)
    end

    it 'setting' do
      parsms = ['-t', '123', '-m', '-C', 'channel', '-u',
                'leon', '-r', '0.6']
      arg = args.new(parsms)
      expect(arg.rate_limit).to eq(0.6)
    end
  end

  context 'validates_args' do
    {
      ['-m', '-D', 'direct', '-u', 'user'] => '--token',
      ['-t', '123'] => '--message, --file',
      ['-t', '123', '-m'] => '--channel, --direct, --group, --mpdirect',
      ['-t', '123', '-m', '-C', 'channel'] => '--user, --bot'
    }.each do |params, must|
      it_behaves_like 'must required', params, must
    end

    {
      ['-t', '123', '-m', '-f', '123'] => '--message, --file',
      ['-t', '123', '-m', '-C', 'channel', '-D', 'direct']   => '--channel, --direct',
      ['-t', '123', '-m', '-C', 'channel', '-G', 'group']    => '--channel, --group',
      ['-t', '123', '-m', '-C', 'channel', '-M', 'mpdirect'] => '--channel, --mpdirect',
      ['-t', '123', '-m', '-D', 'direct', '-G', 'group']     => '--direct, --group',
      ['-t', '123', '-m', '-D', 'direct', '-M', 'mpdirect']  => '--direct, --mpdirect',
      ['-t', '123', '-m', '-G', 'group', '-M', 'mpdirect']   => '--group, --mpdirect',
      ['-t', '123', '-m', '-C', 'channel', '-D', 'direct', '-G', 'group'] => '--channel, --direct, --group',
      ['-t', '123', '-m', '-C', 'channel', '-D', 'direct', '-M', 'mpdirect'] => '--channel, --direct, --mpdirect',
      ['-t', '123', '-m', '-D', 'direct', '-G', 'group', '-M', 'mpdirect'] => '--direct, --group, --mpdirect',
      ['-t', '123', '-C', 'channel', '-u', 'leon', '-b', 'bot', '-f', 'all']=> '--file, --bot',
      ['-t', '123', '-C', 'channel', '-u', 'leon', '-f', 'all', '-R', 'cleaner']=> '--file, --regex',
      ['-t', '123', '-C', 'channel', '-u', 'leon', '-f', 'all', '-b', 'bot']=> '--file, --bot'
    }.each do |params, not_together|
      it_behaves_like 'can not be required together', params, not_together
    end
  end
end
