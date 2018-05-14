class CreateVTigerPipeLineEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :v_tiger_pipe_line_entities do |t|
      t.string :vtiger_from_id
      t.string :vtiger_to_id
      t.string :kind
      t.integer :state
      t.references :crm_from
      t.references :crm_to
      t.json :data

      t.timestamps
    end
  end
end
