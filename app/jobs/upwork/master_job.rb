class Upwork::MasterJob < Upwork::BaseJob
  queue_as :upwork_master

  def perform
    scheduled_ids = Sidekiq::Queue.all.map { |queue| queue.map { |job| job['args'][0]['job_id'] } }.flatten
    running_ids = Sidekiq::Workers.new.map { |_pid, _tid, work| work['payload']['args'][0]['job_id'] }
    job_ids = (scheduled_ids + running_ids).uniq

    Upwork::User.where(locked: false).each do |user|
      next if job_ids.include?(user.sidekiq_jid)

      job = Upwork::FetchJobAndClientInformationJob.perform_later(user.id)
      user.update(sidekiq_jid: job.job_id)

      puts("#{user.email.yellow} hired for work: #{user.sidekiq_jid}")
    end
  end
end
