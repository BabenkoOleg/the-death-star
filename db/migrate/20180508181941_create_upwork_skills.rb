class CreateUpworkSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_skills do |t|
      t.string :title

      t.timestamps
    end
  end
end
