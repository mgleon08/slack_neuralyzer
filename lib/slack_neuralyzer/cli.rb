module SlackNeuralyzer
  class Cli
    attr_reader :args, :dict

    def initialize(args, dict)
      @args = args
      @dict = dict
    end

    def run
      if args.show
        puts dict.show_all_channels
      elsif args.message
        Cleaner::Messages.new(args, dict).clean
      elsif args.file
        Cleaner::Files.new(args, dict).clean
      end
    end
  end
end
