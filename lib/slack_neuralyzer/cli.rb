module SlackNeuralyzer
  class Cli
    attr_reader :args, :dict

    def initialize(args, dict)
      @args = args
      @dict = dict
    end

    def run
      puts dict.show_all_channels if args.show
    end
  end
end
