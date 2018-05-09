class CreateUpworkProxies < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_proxies do |t|
      t.string :host
      t.integer :port
    end
  end
end
