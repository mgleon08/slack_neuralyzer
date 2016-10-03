$LOAD_PATH << File.dirname(__FILE__)

require 'optparse'

require 'slack_neuralyzer/args_parser'
require 'slack_neuralyzer/errors/mutually_exclusive_arguments'
require 'slack_neuralyzer/errors/required_arguments'

require 'slack_neuralyzer/version'
