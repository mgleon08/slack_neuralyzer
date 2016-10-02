module SlackNeuralyzer
  class ArgsParser
    attr_accessor :token, :show, :message, :file, :channel, :direct,
                  :group, :mpdirect, :user, :bot, :after, :before,
                  :execute, :log, :rate

    def initialize(args)
      @args = args
      parse_args
    end

    private

    def parse_args
      opts = OptionParser.new
      opts.banner = usage_msg
      opts.separator ''
      opts.separator 'options:'
      opts.on('-t', '--token TOKEN', 'Slack API token (https://api.slack.com/web)') { |token| self.token = token }
      opts.on('-s', '--show', 'Show all users, channels, groups and multiparty direct names') { self.show = true }

      opts.on('-m', '--message', 'Specifies that the deleted object is messages') { self.message = true }
      opts.on('-f', '--file', 'Specifies that the deleted object is files') { self.file = true }

      opts.on('-C', '--channel CHANNEL', 'Channel name (e.g., general, random)') { |channel| self.channel = channel }
      opts.on('-D', '--direct DIRECT', 'Direct messages name (e.g., leon)') { |direct| self.direct = direct }
      opts.on('-G', '--group GROUP', 'Private channels name') { |group| self.group = group }
      opts.on('-M', '--mpdirect MPDIRECT', 'Multiparty direct messages name (e.g., mpdm-leon--bot-1 [--show option to see name])') { |mpdirect| self.mpdirect = mpdirect }

      opts.on('-u', '--user USER', "Delete messages from the specific user (if you want to specific all users, you can type '*')") { |user| self.user = user }
      opts.on('-b', '--bot', 'Delete messages from the bots') { self.bot = true }

      opts.on('-A', '--after AFTER', 'Delete messages after than this time (YYYYMMDD)') { |after| self.after = after }
      opts.on('-B', '--before BEFORE', 'Delete messages before than this time (YYYYMMDD)') { |before| self.before = before }

      opts.on('-e', '--execute', 'Execute the delete task') { self.execute = true }
      opts.on('-l', '--log', 'Generate a log file in the current directory') { self.log = true }
      opts.on('-r', '--rate RATE', Float, 'Delay between API calls in seconds (default:0.1)') { |rate| self.rate = rate }
      opts.on('-h', '--help', 'Show this message') { puts(opts); exit }
      opts.parse!(@args)
    end

    def usage_msg
      <<-USAGE.freeze
usage:
    slack_neuralyzer [options]
    See https://github.com/mgleon08/slack_neuralyzer for more information.
      USAGE
    end
  end
end