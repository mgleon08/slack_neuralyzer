require 'spec_helper'

describe SlackNeuralyzer::ArgsParser do
  subject(:args) { described_class }

  context 'when type arguments' do
    it 'should get right with short args' do
      parsms = ['-t', '123', '-m', '-f', '-C', 'channel', '-D', 'direct',
                '-G', 'group', '-M', 'mpdirect', '-u', 'user', '-b', 'bot',
                '-A', '20160101', '-B', '20161212', '-e', '-l', '-r', '0.5']

      arg = args.new(parsms)
      expect(arg.token).to    eq '123'
      expect(arg.show).to     eq nil
      expect(arg.message).to  eq true
      expect(arg.file).to     eq true
      expect(arg.channel).to  eq 'channel'
      expect(arg.direct).to   eq 'direct'
      expect(arg.group).to    eq 'group'
      expect(arg.mpdirect).to eq 'mpdirect'
      expect(arg.user).to     eq 'user'
      expect(arg.bot).to      eq true
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
    end

    it 'should get right with long args' do
      parsms = ['--token', '123', '--message', '--file',
                '--channel', 'channel', '--direct', 'direct', '--group',
                'group', '--mpdirect', 'mpdirect', '--user', 'user',
                '--bot', 'bot', '--after', '20160101', '--before',
                '20161212', '--execute', '--log', '--rate', '0.5']

      arg = args.new(parsms)
      expect(arg.token).to    eq '123'
      expect(arg.show).to     eq nil
      expect(arg.message).to  eq true
      expect(arg.file).to     eq true
      expect(arg.channel).to  eq 'channel'
      expect(arg.direct).to   eq 'direct'
      expect(arg.group).to    eq 'group'
      expect(arg.mpdirect).to eq 'mpdirect'
      expect(arg.user).to     eq 'user'
      expect(arg.bot).to      eq true
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
    end
  end
end
