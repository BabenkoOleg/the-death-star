class CreateUpworkUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_users do |t|
      t.string :email
      t.string :password
      t.boolean :busy, default: false
      t.datetime :last_request_at

      t.timestamps
    end
  end
end
