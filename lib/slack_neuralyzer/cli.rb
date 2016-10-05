module SlackNeuralyzer
  class Cli
    include Helper
    attr_reader :args, :dict, :channel_type

    def initialize(args, dict)
      @args = args
      @dict = dict
      reset_counter
      parse_to_ts(args.after, args.before)
    end

    def run
      if args.show
        puts dict.show_all_channels
      elsif args.message
        message_cleaner
      end
    end

    private

    def message_cleaner
      channel_id, end_point = get_channel_id_and_history_end_point
      raise SlackApi::Errors::NotFoundError, "#{current_channel} not found." unless channel_id
      user_id = args.user == '*' ? -1 : dict.find_user_id(args.user)
      raise SlackApi::Errors::NotFoundError, "#{args.user} not found." unless args.bot || user_id
      clean_channel(channel_id, user_id, end_point)
    end

    def clean_channel(channel_id, user_id, end_point)
      has_more = true

      while has_more
        res = Slack.public_send(end_point, channel: channel_id, oldest: start_time, latest: end_time)
        raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
        has_more = res['has_more']
        messages = res['messages']
        puts "#{current_channel} does not have any messages" if messages.empty?
        messages.each do |msg|
          @end_time = msg['ts']
          if msg['type'] == 'message'
            if args.user && (msg['user'] == user_id || user_id == -1)
              delete_message(channel_id, msg)
            end

            if args.bot && msg['subtype'] == 'bot_message'
              delete_message(channel_id, msg)
            end
          end
        end
      end

      puts finish_text
    end

    def delete_message(channel_id, msg)
      puts "[#{parse_to_date(msg['ts'])}] #{dict.find_user_name(msg['user'])}: #{msg['text']}"
      Slack.chat_delete(channel: channel_id, ts: msg['ts']) if args.execute
      increase_counter
      rate_limit
    end

    def get_channel_id_and_history_end_point
      if args.channel
        @channel_type     = 'channel'
        history_end_point = :channels_history
        channel_id        = dict.find_channel_id(args.channel)
      elsif args.direct
        @channel_type     = 'direct'
        history_end_point = :im_history
        user_id           = dict.find_user_id(args.direct)
        channel_id        = dict.find_im_id(user_id)
      elsif args.group
        @channel_type     = 'group'
        history_end_point = :groups_history
        channel_id        = dict.find_group_id(args.group)
      elsif args.mpdirect
        @channel_type     = 'mpdirect'
        history_end_point = :mpim_history
        channel_id        = dict.find_mpim_id(args.mpdirect)
      end

      [channel_id, history_end_point]
    end

    def current_channel
      "#{args.public_send(channel_type)} #{channel_type}"
    end

    def finish_text
      text = "\n#{counter} message(s) in #{current_channel} "

      if args.execute.nil? && counter.nonzero?
        text << 'will be deleted.'
        text << "\n\nNow, you can rerun the command and use `-e | --execute` to actually delete the message(s)."
      else
        text << 'have been deleted.'
      end

      text
    end
  end
end
