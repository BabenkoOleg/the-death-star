class CreateUpworkSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_subcategories do |t|
      t.string :title
      t.string :upwork_id
      t.references :category

      t.timestamps
    end
  end
end
