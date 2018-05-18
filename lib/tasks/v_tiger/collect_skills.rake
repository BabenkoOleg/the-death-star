namespace :v_tiger do
  task collect_skills: :environment do
    right_skills = Upwork::Skill.pluck(:title).sort

    entity_skills =
      VTiger::PipeLine::Entity.all
                              .map { |e| d = JSON.parse(e.data); [d['cf_894'], d['cf_896']] }
                              .flatten
                              .compact
                              .map { |s| s.split(' |##| ') }
                              .flatten
                              .map { |s| s.strip!; s.gsub!(/("|\s\|##\||\s\|##|\s\|#|\s\|)/, ''); s.downcase }
                              .sort
                              .uniq

    uniq_skills = []
    broken_skills = []
    unloaded_skills = []

    entity_skills.each do |s|
      f = entity_skills.find { |f| f[s].present? && f.size > s.size && f[s.size] != '.' && f[s.size] != ' '}
      uniq_skills << s unless f.present?
    end

    uniq_skills.each do |s|
      t = s.gsub(' ', '-')
      next (unloaded_skills << t) if right_skills.include?(t)

      t = s.gsub(/\.|\s/, '-')
      next (unloaded_skills << t) if right_skills.include?(t)

      t = s.gsub('.', '-').gsub('.', '')
      next (unloaded_skills << t) if right_skills.include?(t)

      broken_skills << t
    end
  end
end
