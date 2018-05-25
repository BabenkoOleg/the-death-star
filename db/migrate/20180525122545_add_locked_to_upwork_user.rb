class AddLockedToUpworkUser < ActiveRecord::Migration[5.2]
  def change
    add_column :upwork_users, :locked, :boolean, default: false
  end
end
