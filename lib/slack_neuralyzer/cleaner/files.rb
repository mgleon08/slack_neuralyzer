module SlackNeuralyzer
  module Cleaner
    class Files < Base
      def clean
        user_id    = get_user_id
        channel_id = get_channel_id
        clean_channel_file(channel_id, user_id)
      end

      private

      def clean_channel_file(channel_id, user_id)
        page, total_page = 0, nil
        until page == total_page
          page += 1
          res = Slack.files_list(page: page, channel: channel_id, types: args.file, ts_from: start_time, ts_to: end_time)
          raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
          total_page = res['paging']['pages']
          not_have_any('file') if total_page.zero?
          res['files'].each do |file|
            if args.user && (file['user'] == user_id || user_id == -1)
              delete_file(file)
            end
          end
        end

        puts finish_text('file')
      end

      def delete_file(file)
        file_time = time_format(file['timestamp'])
        file_url  = light_magenta("(#{file['permalink']})")
        delete    = delete_format
        puts "#{delete}#{file_time} #{dict.find_user_name(file['user'])}: #{file['name']} #{file_url}"
        Slack.files_delete(file: file['id']) if args.execute
        increase_counter
        rate_limit
      end
    end
  end
end
