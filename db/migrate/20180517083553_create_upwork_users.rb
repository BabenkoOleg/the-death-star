class CreateUpworkUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_users do |t|
      t.string :email
      t.string :password
      t.string :user_agent
      t.string :sidekiq_jid
      t.integer :waiting_time, default: 1
      t.boolean :locked, :boolean, default: false
      t.datetime :last_request_at

      t.timestamps
    end
  end
end
