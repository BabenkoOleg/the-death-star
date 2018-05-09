class CreateUpworkJobsSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_jobs_skills, id: false do |t|
      t.references :job
      t.references :skill
    end
  end
end
