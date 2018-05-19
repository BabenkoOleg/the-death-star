class Upwork::BaseJob < ApplicationJob
  def logger
    @logger ||= Logger.new("#{Rails.root}/log/upwork.log")

    @logger = Logger.new("#{Rails.root}/log/upwork.log")
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      if severity == 'INFO' || severity == 'WARN'
        "[#{date_format}]  #{severity} -- : #{msg}\n"
      else
        "[#{date_format}] #{severity} -- : #{msg}\n"
      end
    end

    @logger
  end

  def log(type, message)
    @logger.send(type, "#{self.class.to_s.split('::').last.pink} #{message}")
  end
end
