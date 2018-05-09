namespace :upwork do
  desc 'Update the list of available skills'
  task fetch_skills: :environment do
    client = Upwork::Crawler::Api.new

    skills_data = client.fetch(:skills)['skills']

    skills_data.each do |title|
      skill = Upwork::Skill.find_or_create_by(title: title)

      puts " --> processed skill \e[1m\e[32m#{skill.title}\e[0m\e[22m"
    end
  end
end
