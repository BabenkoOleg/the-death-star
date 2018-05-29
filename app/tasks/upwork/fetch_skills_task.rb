module Upwork
  class FetchSkillsTask < BaseTask
    def perform!
      client = Upwork::Api.new

      skills_data = client.fetch(:skills)['skills']

      skills_data.sort.each do |title|
        skill = Upwork::Skill.find_or_create_by(title: title)
        puts " --> processed skill \e[1m\e[32m#{skill.title}\e[0m\e[22m"
      end
    end
  end
end
