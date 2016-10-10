module SlackNeuralyzer
  class Cli
    attr_reader :args, :dict, :logger

    def initialize(args, dict, logger)
      @args   = args
      @dict   = dict
      @logger = logger
    end

    def run
      logger.info "Running slack_neuralyzer v#{SlackNeuralyzer::VERSION}\n"
      sleep(1)
      if args.show
        puts dict.show_all_channels
      elsif args.message
        Cleaner::Messages.new(args, dict, logger).clean
      elsif args.file
        Cleaner::Files.new(args, dict, logger).clean
      end
    end
  end
end
