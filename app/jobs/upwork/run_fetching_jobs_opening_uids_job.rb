class Upwork::RunFetchingJobsOpeningUidsJob < ApplicationJob
  queue_as :upwork

  def perform
    jobs = Upwork::Job.where(parsing_state: :expecting_opening_uid).limit(100)
    jobs.each { |job| Upwork::FetchJobOpeningUidJob.perform_later(job.id) }
  end
end
