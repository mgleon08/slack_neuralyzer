module SlackNeuralyzer
  class ArgsParser
    attr_accessor :token, :show, :message, :file, :channel, :direct,
                  :group, :mpdirect, :user, :bot, :after, :before,
                  :execute, :log, :rate, :regex

    def initialize(args)
      @args = args
      init_arg_groups
      parse_args
      validates_args
    end

    def init_arg_groups
      @arg_groups = {
        'token':   [:token],
        'action':  [:message, :file],
        'channel': [:channel, :direct, :group, :mpdirect],
        'from':    [:user, :bot]
      }
    end

    def rate_limit
      rate || 0.1
    end

    private

    def parse_args
      opts = OptionParser.new
      opts.banner = usage_msg
      opts.separator ''
      opts.separator 'options:'
      opts.on('-t', '--token TOKEN', 'Slack API token (https://api.slack.com/web)') { |token| self.token = token }
      opts.on('-s', '--show', 'Show all users, channels, groups and multiparty direct names') { self.show = true }

      opts.on('-m', '--message', 'Specifies that the delete object is messages') { self.message = true }
      opts.on('-f', '--file TYPE', "Specifies that the delete object is files of a certain type (Type: all, spaces, snippets, images, gdocs, docs, zips, pdfs)") { |file| self.file = file }

      opts.on('-C', '--channel CHANNEL', 'Public channel name (e.g., general, random)') { |channel| self.channel = channel }
      opts.on('-D', '--direct DIRECT', 'Direct messages channel name (e.g., leon)') { |direct| self.direct = direct }
      opts.on('-G', '--group GROUP', 'Private groups channel name') { |group| self.group = group }
      opts.on('-M', '--mpdirect MPDIRECT', 'Multiparty direct messages channel name (e.g., mpdm-leon--bot-1 [--show option to see name])') { |mpdirect| self.mpdirect = mpdirect }

      opts.on('-u', '--user USER', "Delete messages/files from the specific user (if you want to specific all users, you can type 'all')") { |user| self.user = user }
      opts.on('-b', '--bot', 'Delete messages from the bots (not bot users)') { self.bot = true }

      opts.on('-A', '--after DATE', 'Delete messages/files after than this time (YYYYMMDD)') { |after| self.after = after }
      opts.on('-B', '--before DATE', 'Delete messages/files before than this time (YYYYMMDD)') { |before| self.before = before }

      opts.on('-R', '--regex TEXT', 'Delete messages with specified text (regular expression)') { |regex| self.regex = regex }

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

    def validates_args
      @arg_groups.each do |key, opts|
        filters = opts.select{ |opt| !self.public_send(opt).nil? }
        raise SlackNeuralyzer::Errors::MutuallyExclusiveArgumentsError.new(double_dash(filters).join(', ')) if filters.size > 1
        raise SlackNeuralyzer::Errors::RequiredArgumentsError.new(double_dash(opts).join(', ')) if filters.empty?
        return if !self.show.nil?
      end
    end

    def double_dash(arrays)
      arrays.map{ |array| array.to_s.prepend('--') }
    end
  end
end
