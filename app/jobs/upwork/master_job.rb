class Upwork::MasterJob < Upwork::BaseJob
  queue_as :upwork_master

  def perform
    Upwork::User.free.each do |user|
      Upwork::FetchJobAndClientInformationJob.perform_later(user.id)
      log(:info, "#{user.email.yellow} hired for work")
    end
  end
end
