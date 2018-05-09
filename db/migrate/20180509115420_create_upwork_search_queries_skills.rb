class CreateUpworkSearchQueriesSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_search_queries_skills do |t|
      t.references :search_query
      t.references :skill
    end
  end
end

