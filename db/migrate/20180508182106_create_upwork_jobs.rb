class CreateUpworkJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_jobs do |t|
      t.string :title
      t.string :status
      t.string :pricing
      t.string :duration
      t.string :workload
      t.string :opening_uid
      t.string :description
      t.string :url, null: false
      t.string :upwork_id, null: false
      t.string :upwork_client_id
      t.integer :slack_state, default: 0
      t.integer :parsing_state, default: 0
      t.float :budget
      t.datetime :created_date
      t.references :client
      t.references :category
      t.references :subcategory

      t.timestamps
    end
  end
end
