class CreateVTigerCrms < ActiveRecord::Migration[5.2]
  def change
    create_table :v_tiger_crms do |t|
      t.string :name
      t.string :api_url
      t.string :email
      t.string :access_key

      t.timestamps
    end
  end
end
