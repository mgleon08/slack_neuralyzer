module SlackNeuralyzer
  class Logger < ::Logger
    class << self
      def default(log)
        io = [STDOUT]
        io << log_file if log
        logger = Logger.new(MultiIO.new(*io))
        logger.level = Logger::INFO
        logger.formatter = proc do |_severity, _datetime, _progname, msg|
          "#{msg}\n"
        end
        logger
      end

      def log_file
        time = Time.now.strftime('%Y-%m-%dT%H:%M:%S')
        FileUtils.mkdir_p('./slack_neuralyzer')
        log_file = File.open("./slack_neuralyzer/#{time}.log", 'a')
        log_file
      end
    end
  end
end
