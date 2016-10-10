module SlackNeuralyzer
  module Helper
    attr_reader :counter, :start_time, :end_time

    def parse_to_ts(start_time, end_time)
      end_time ||= Time.now.to_s
      @start_time = Time.parse(start_time).to_f if start_time
      @end_time   = Time.parse(end_time).to_f
    end

    def parse_to_date(ts)
      Time.at(ts.to_f).strftime('%Y-%m-%d %H:%M')
    end

    def reset_counter
      @counter = 0
    end

    def increase_counter
      @counter += 1
    end
  end
end
