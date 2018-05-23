class CreateUpworkClients < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_clients do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :city
      t.string :country
      t.string :state
      t.string :world_region
      t.string :opening_uid
      t.string :upwork_id, null: false
      t.string :vtiger_id
      t.string :vtiger_state, default: 0
      t.integer :active_assignments_count
      t.integer :feedback_count
      t.integer :hours_count
      t.integer :total_assignments
      t.integer :total_charges
      t.integer :total_jobs_with_hires
      t.integer :filled_count
      t.integer :open_count
      t.integer :posted_count
      t.float :score
      t.float :avg_hourly_jobs_rate
      t.boolean :is_payment_method_verified
      t.datetime :contract_date

      t.timestamps
    end
  end
end

