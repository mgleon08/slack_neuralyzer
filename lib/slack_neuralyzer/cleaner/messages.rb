module SlackNeuralyzer
  module Cleaner
    class Messages < Base
      def clean
        user_id    = get_user_id
        channel_id = get_channel_id
        end_point  = get_history_end_point
        clean_channel_messages(channel_id, user_id, end_point)
      end

      private

      def clean_channel_messages(channel_id, user_id, end_point)
        has_more = true

        while has_more
          res = Slack.public_send(end_point, channel: channel_id, oldest: start_time, latest: end_time)
          raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
          has_more = res['has_more']
          messages = res['messages']
          not_have_any('message') if messages.empty?

          messages.each do |msg|
            @end_time = msg['ts']
            dict.scan_user_id_to_transform(msg['text'])
            next unless msg['type'] == 'message'
            next unless match_regex(msg['text']) if args.regex

            if args.user && (msg['user'] == user_id || user_id == -1)
              delete_message(channel_id, msg)
            end

            if args.bot && msg['subtype'] == 'bot_message'
              delete_message(channel_id, msg)
            end
          end
        end

        logger.info finish_text('message')
      end

      def delete_message(channel_id, msg)
        msg_time = time_format(msg['ts'])
        delete   = delete_format
        logger.info "#{delete}#{msg_time} #{dict.find_user_name(msg['user'])}: #{msg['text']}"
        Slack.chat_delete(channel: channel_id, ts: msg['ts']) if args.execute
        increase_counter
        sleep(args.rate_limit)
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

      def match_regex(text)
        match_word = text.scan(/#{args.regex}/).flatten
        return false if match_word.empty?
        match_word.uniq.each do |word|
          text.gsub!(/#{word}/, light_magenta("#{word}"))
        end
        text
      end
    end
  end
end
