module SlackNeuralyzer
  module Cleaner
    class Base
      include Helper
      include Colorizable
      attr_reader :args, :dict, :channel_type

      def initialize(args, dict)
        @args = args
        @dict = dict
        reset_counter
        parse_to_ts(args.after, args.before)
      end

      private

      def get_user_id
        user_id = args.user == 'all' ? -1 : dict.find_user_id(args.user)
        raise SlackApi::Errors::NotFoundError, "#{args.user} not found." unless args.bot || user_id
        user_id
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
        raise SlackApi::Errors::NotFoundError, "#{current_channel} not found." unless channel_id
        channel_id
      end

      def current_channel
        light_green("#{args.public_send(channel_type)} #{channel_type}")
      end

      def time_format(time)
        light_cyan("[#{parse_to_date(time)}]")
      end

      def delete_format
        args.execute ? "(delete) ".light_red : ''
      end

      def not_have_any(type)
        puts "#{current_channel} does not have any #{type}(s)"
        exit
      end

      def finish_text(type)
        text = "\n#{light_green(counter)} #{type}(s) in #{current_channel} "
        if args.execute.nil? && counter.nonzero?
          text << 'will be deleted.'
          text << light_red("\nNow, you can rerun the command and use `-e | --execute` to actually delete the #{type}(s).")
        else
          text << 'have been deleted.'
        end
        text
      end
    end
  end
end
