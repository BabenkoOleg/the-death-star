module Upwork
  module Crawler
    class Logger

      attr_accessor :logger
      attr_reader :bot

      def initialize(bot)
        @bot = bot
        @logger = ::Logger.new("#{Rails.root}/log/upwork.log")
        @logger.formatter = proc do |severity, datetime, _progname, msg|
          date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
          if severity == 'INFO' || severity == 'WARN'
            "[#{date_format}] ID-#{bot.id}  #{severity} -- : #{msg}\n"
          else
            "[#{date_format}] ID-#{bot.id} #{severity} -- : #{msg}\n"
          end
        end
      end

      def log(type, message)
        logger.send(type, message)
      end
    end
  end
end
