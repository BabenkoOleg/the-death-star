class Upwork::FetchJobsJob < ApplicationJob
  queue_as :upwork_fetching_jobs

  def perform
    client = Upwork::Api.new
    queries = Upwork::SearchQuery.includes(:category, :subcategory, :skills).all

    fetched_jobs = queries.map do |query|
      jobs_data = client.fetch(:jobs, query.to_hash)['jobs']

      unless query.came_to_end?
        jobs_data.any? ? query.next_page! : query.update(came_to_end: true, page: 0)
      end

      jobs_data
    end.flatten.uniq

    fetched_jobs.each do |data|
      skills = Upwork::Skill.where(title: data['skills'])
      category = Upwork::Category.find_by(title: data['category2'])
      subcategory = category.subcategories.find_by(title: data['subcategory2'])

      attributes = {
        url: data['url'],
        title: data['title'],
        skills: skills,
        status: data['job_status'],
        budget: data['budget'],
        pricing: data['job_type'],
        duration: data['duration'],
        workload: data['workload'],
        category: category,
        upwork_id: data['id'],
        created_at: DateTime.parse(data['date_created']),
        subcategory: subcategory,
        description: data['snippet']
      }

      job = Upwork::Job.find_by(upwork_id: data['id'])
      job.present? ? job.update(attributes) : Upwork::Job.create(attributes)
    end
  end
end
