class CreateUpworkProxies < ActiveRecord::Migration[5.2]
  def change
    create_table :upwork_proxies do |t|
      t.string :host
      t.integer :port
      t.integer :state, default: 0
      t.boolean :busy, default: false
      t.datetime :last_request_at
      t.boolean :got_recaptcha, default: false
      t.datetime :got_recaptcha_at
    end
  end
end
