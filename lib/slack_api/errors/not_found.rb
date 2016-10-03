module SlackApi
  module Errors
    class NotFoundError < StandardError
      def initialize(message)
        super("SlackAPI: #{message}")
      end
    end
  end
end
