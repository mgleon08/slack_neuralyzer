require 'spec_helper'

describe SlackNeuralyzer::ArgsParser do
  subject(:args) { described_class }

  context 'when type arguments' do
    it 'should get right with short args' do
      allow_any_instance_of(args).to receive(:validates_args)
      parsms = ['-t', '123', '-m', '-f', 'all', '-C', 'channel', '-D', 'direct',
                '-G', 'group', '-M', 'mpdirect', '-u', 'user', '-b', 'bot',
                '-A', '20160101', '-B', '20161212', '-e', '-l', '-r', '0.5']

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
      expect(arg.bot).to      eq true
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
    end

    it 'should get right with long args' do
      allow_any_instance_of(args).to receive(:validates_args)
      parsms = ['--token', '123', '--message', '--file', 'all',
                '--channel', 'channel', '--direct', 'direct', '--group',
                'group', '--mpdirect', 'mpdirect', '--user', 'user',
                '--bot', 'bot', '--after', '20160101', '--before',
                '20161212', '--execute', '--log', '--rate', '0.5']

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
      expect(arg.bot).to      eq true
      expect(arg.after).to    eq '20160101'
      expect(arg.before).to   eq '20161212'
      expect(arg.execute).to  eq true
      expect(arg.log).to      eq true
      expect(arg.rate).to     eq 0.5
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

  context 'arguments check' do
    it 'must require --token' do
      parsms = ['-m', '-D', 'direct', '-u', 'user']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::RequiredArgumentsError,
        'Must required one of these arguments: --token'
      )
    end

    it 'must required one of these arguments :message, :file' do
      parsms = ['-t', '123']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::RequiredArgumentsError,
        'Must required one of these arguments: --message, --file'
      )
    end

    it 'should not required together :show, :message, :file' do
      parsms = ['-t', '123', '-m', '-f', '123']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::MutuallyExclusiveArgumentsError,
        'These arguments can not be required together: --message, --file'
      )
    end

    it 'must required one of these arguments :channel, :direct, :group, :mpdirect' do
      parsms = ['-t', '123', '-m']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::RequiredArgumentsError,
        'Must required one of these arguments: --channel, --direct, --group, --mpdirect'
      )
    end

    it 'should not required together :show, :channel, :direct, :group, :mpdirect' do
      parsms = ['-t', '123', '-m', '-C', 'channel', '-D',
                'direct', '-G', 'group', '-M', 'mpdirect']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::MutuallyExclusiveArgumentsError,
        'These arguments can not be required together: --channel, --direct, --group, --mpdirect'
      )
    end

    it 'must required one of these arguments :user, :bot' do
      parsms = ['-t', '123', '-m', '-C', 'channel']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::RequiredArgumentsError,
        'Must required one of these arguments: --user, --bot'
      )
    end

    it 'should not required together :show, :channel, :direct, :group, :mpdirect' do
      parsms = ['-t', '123', '-m', '-C', 'channel', '-u',
                'leon', '-b']
      expect { args.new(parsms) }.to raise_error(
        SlackNeuralyzer::Errors::MutuallyExclusiveArgumentsError,
        'These arguments can not be required together: --user, --bot'
      )
    end
  end
end
