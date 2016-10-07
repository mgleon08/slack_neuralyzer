module SlackNeuralyzer
  class Cli
    include Helper
    include Colorizable
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
      elsif args.file
        file_cleaner
      end
    end

    private

    def file_cleaner
      channel_id = get_channel_id
      raise SlackApi::Errors::NotFoundError, "#{current_channel} not found." unless channel_id
      user_id = args.user == 'all' ? -1 : dict.find_user_id(args.user)
      raise SlackApi::Errors::NotFoundError, "#{args.user} not found." unless args.bot || user_id
      clean_channel_file(channel_id, user_id)
    end

    def clean_channel_file(channel_id, user_id)
      page, total_page = 0, nil
      until page == total_page
        page += 1
        res = Slack.files_list(page: page, channel: channel_id, types: args.file, ts_from: start_time, ts_to: end_time)
        raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
        total_page = res['paging']['pages']
        if total_page.zero?
          puts "#{current_channel} does not have any files"
          exit
        end
        res['files'].each do |file|
          if args.user && (file['user'] == user_id || user_id == -1)
            delete_file(file)
          end
        end
      end

      puts finish_text
    end

    def delete_file(file)
      file_time = light_cyan("[#{parse_to_date(file['timestamp'])}]")
      file_url  = light_magenta("(#{file['permalink']})")
      delete    = args.execute ? "(delete) ".light_red : ''
      puts "#{delete}#{file_time} #{dict.find_user_name(file['user'])}: #{file['name']} #{file_url}"
      Slack.files_delete(file: file['id']) if args.execute
      increase_counter
      rate_limit
    end

    def message_cleaner
      channel_id = get_channel_id
      end_point  = get_history_end_point
      raise SlackApi::Errors::NotFoundError, "#{current_channel} not found." unless channel_id
      user_id = args.user == 'all' ? -1 : dict.find_user_id(args.user)
      raise SlackApi::Errors::NotFoundError, "#{args.user} not found." unless args.bot || user_id
      clean_channel_messages(channel_id, user_id, end_point)
    end

    def clean_channel_messages(channel_id, user_id, end_point)
      has_more = true

      while has_more
        res = Slack.public_send(end_point, channel: channel_id, oldest: start_time, latest: end_time)
        raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
        has_more = res['has_more']
        messages = res['messages']
        puts "#{current_channel} does not have any messages" if messages.empty?
        messages.each do |msg|
          @end_time = msg['ts']
          next unless msg['type'] == 'message'
          if args.user && (msg['user'] == user_id || user_id == -1)
            delete_message(channel_id, msg)
          end

          if args.bot && msg['subtype'] == 'bot_message'
            delete_message(channel_id, msg)
          end
        end
      end

      puts finish_text
    end

    def delete_message(channel_id, msg)
      dict.scan_user_id_to_transform(msg['text'])
      msg_time = light_cyan("[#{parse_to_date(msg['ts'])}]")
      puts "#{msg_time} #{dict.find_user_name(msg['user'])}: #{msg['text']}"
      Slack.chat_delete(channel: channel_id, ts: msg['ts']) if args.execute
      increase_counter
      rate_limit
    end

    def get_channel_id
      if args.channel
        @channel_type = 'channel'
        channel_id    = dict.find_channel_id(args.channel)
      elsif args.direct
        @channel_type = 'direct'
        user_id       = dict.find_user_id(args.direct)
        channel_id    = dict.find_im_id(user_id)
      elsif args.group
        @channel_type = 'group'
        channel_id    = dict.find_group_id(args.group)
      elsif args.mpdirect
        @channel_type = 'mpdirect'
        channel_id    = dict.find_mpim_id(args.mpdirect)
      end
    end

    def get_history_end_point
      if args.channel
        history_end_point = :channels_history
      elsif args.direct
        history_end_point = :im_history
      elsif args.group
        history_end_point = :groups_history
      elsif args.mpdirect
        history_end_point = :mpim_history
      end
    end

    def current_channel
      "#{args.public_send(channel_type)} #{channel_type}"
    end

    def finish_text
      object = args.message ? 'message' : 'file'
      text = "\n#{light_green(counter)} #{object}(s) in #{current_channel} "
      if args.execute.nil? && counter.nonzero?
        text << 'will be deleted.'
        text << light_red("\nNow, you can rerun the command and use `-e | --execute` to actually delete the #{object}(s).")
      else
        text << 'have been deleted.'
      end
      text
    end
  end
end
