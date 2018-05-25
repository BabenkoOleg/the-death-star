ActiveAdmin.register Upwork::Client do
  menu label: 'Clients', parent: 'Upwork', priority: 2

  permit_params :name, :description, :url, :city, :country, :state, :world_region, :opening_uid, :upwork_id,
                :vtiger_id, :vtiger_state, :active_assignments_count, :feedback_count, :hours_count, :total_assignments,
                :total_charges, :total_jobs_with_hires, :filled_count, :open_count, :posted_count, :score,
                :avg_hourly_jobs_rate, :is_payment_method_verified, :contract_date

  config.sort_order = 'id_asc'
end
