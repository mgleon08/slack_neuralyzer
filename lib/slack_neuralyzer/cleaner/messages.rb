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
            next if args.regex && !match_regex(msg['text'])

            if args.user && user_msg?(msg, user_id)
              name = dict.find_user_name(msg['user'])
              delete_message(channel_id, msg, name)
            end

            next unless args.bot && bot_msg?(msg)

            name = dict.find_bot_name(msg['bot_id'])
            if args.bot == name || args.bot == 'all'
              delete_message(channel_id, msg, name)
            end
          end
        end

        logger.info finish_text('message')
      end

      def user_msg?(msg, user_id)
        !bot_msg?(msg) && (msg['user'] == user_id || user_id == -1)
      end

      def bot_msg?(msg)
        msg['subtype'] == 'bot_message'
      end

      def delete_message(channel_id, msg, name)
        Slack.chat_delete(channel: channel_id, ts: msg['ts']) if args.execute
        logger.info "#{delete_format}#{time_format(msg['ts'])} #{name}: #{msg['text']}"
        increase_counter
        sleep(args.rate_limit)
      end

      def get_history_end_point
        if args.channel
          :channels_history
        elsif args.direct
          :im_history
        elsif args.group
          :groups_history
        elsif args.mpdirect
          :mpim_history
        end
      end

      def match_regex(text)
        match_word = text.scan(/#{args.regex}/).flatten
        return false if match_word.empty?
        match_word.uniq.each do |word|
          text.gsub!(/#{word}/, light_magenta(word.to_s))
        end
        text
      end
    end
  end
end
