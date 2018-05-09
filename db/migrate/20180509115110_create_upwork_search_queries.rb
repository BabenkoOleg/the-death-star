class CreateUpworkSearchQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_search_queries do |t|
      t.string :q
      t.string :title
      t.string :cache_category
      t.integer :page, default: 0
      t.boolean :came_to_end, default: false
      t.references :category
      t.references :subcategory

      t.timestamps
    end
  end
end
