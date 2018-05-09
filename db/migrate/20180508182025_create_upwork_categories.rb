class CreateUpworkCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_categories do |t|
      t.string :title
      t.string :upwork_id

      t.timestamps
    end
  end
end
