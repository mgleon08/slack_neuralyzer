module SlackApi
  module Errors
    class ResponseError < StandardError
      def initialize(message)
        super("SlackAPI: #{message}")
      end
    end
  end
end
