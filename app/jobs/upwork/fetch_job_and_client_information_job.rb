class Upwork::FetchJobAndClientInformationJob < Upwork::BaseJob
  queue_as :upwork_fetching_information

  def perform(user_id)
    user = Upwork::User.find(user_id)

    bot = Upwork::Crawler::Bot.new(user)
    bot.run!
  end
end
