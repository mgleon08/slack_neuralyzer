module SlackNeuralyzer
  module Errors
    class MutuallyExclusiveArgumentsError < StandardError
      def initialize(message)
        super("These arguments can not be required together: #{message}")
      end
    end
  end
end
