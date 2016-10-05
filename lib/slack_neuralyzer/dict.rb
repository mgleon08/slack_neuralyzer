module SlackNeuralyzer
  class Dict
    attr_reader :channels, :ims, :groups, :mpims, :users

    def initialize(token)
      Slack.token = token
      @users = {}
      @channels = {}
      @groups = {}
      @ims = {}
      @mpims = {}
      init_all_dict
    end

    def show_all_channels
      text = ''
      text << "All user direct:\n"
      text << list_names(users)
      text << "\nAll channels (public):\n"
      text << list_names(channels)
      text << "\nAll groups (private):\n"
      text << list_names(groups)
      text << "\nAll multiparty direct:\n"
      text << list_names(mpims)
    end

    [:channel, :im, :group, :mpim, :user].each do |channel|
      define_method("find_#{channel}_id".to_sym) do |name|
        public_send("#{channel}s").key(name)
      end

      define_method("find_#{channel}_name".to_sym) do |name|
        public_send("#{channel}s").invert.key(name)
      end
    end

    def scan_user_id_to_transform(text)
      return text if text.nil?
      scan_id = text.scan(/<@(?<bot>[[:alnum:][:punct:]]*)>/i).flatten
      if scan_id.any?
        scan_id.uniq.each do |id|
          name = find_user_name(id)
          text.gsub!(/<@#{id}>/, "@#{name}")
        end
      end
      text
    end

    private

    def init_all_dict
      init_users_dict
      init_channels_dict
      init_groups_dict
      init_ims_dict
      init_mpims_dict
    end

    def init_users_dict
      res = Slack.users_list
      raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
      members = res['members']
      members.each { |member| @users[member['id']] = member['name'] }
    end

    def init_channels_dict
      res = Slack.channels_list
      raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
      channels = res['channels']
      channels.each { |channel| @channels[channel['id']] = channel['name'] }
    end

    def init_groups_dict
      res = Slack.groups_list
      raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
      groups = res['groups']
      groups.each do |group|
        next if group['is_mpim'] != false
        @groups[group['id']] = group['name']
      end
    end

    def init_ims_dict
      res = Slack.im_list
      raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
      ims = res['ims']
      ims.each { |im| @ims[im['id']] = im['user'] }
    end

    def init_mpims_dict
      res = Slack.mpim_list
      raise SlackApi::Errors::ResponseError, res['error'] unless res['ok']
      mpims = res['groups']
      mpims.each { |mpim| @mpims[mpim['id']] = mpim['name'] }
    end

    def list_names(names)
      ''.tap do |text|
        names.values.each.with_index(1) do |name, index|
          text << "#{index.to_s.rjust(3, '0')}. #{name}\n"
        end
      end
    end
  end
end
