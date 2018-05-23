namespace :upwork do
  desc 'Fetch data from the old crm'
  task from_v_tiger_to_upwork: :environment do
    fields = {
      "lastname" => :name,
      "description" => :description,
      "city" => :city,
      "country" => :country,
      "cf_leads_upworkid" => :upwork_id,
      "cf_leads_upworkactiveassignmentscount" => :active_assignments_count,
      "cf_leads_upworkfeedbackcount" => :feedback_count,
      "cf_leads_upworkhourscount" => :hours_count,
      "cf_leads_upworktotalassignments" => :total_assignments,
      "cf_leads_upworktotalcharges" => :total_charges,
      "cf_leads_upworkfilledcount" => :filled_count,
      "cf_leads_upworkopencount" => :open_count,
      "cf_leads_upworkpostedcount" => :posted_count,
      "cf_leads_upworkscore" => :score,
      "cf_leads_upworkavghourlyjobsrate" => :avg_hourly_jobs_rate,
      "cf_leads_upworkcontractdate" => :contract_date
    }

    binding.pry
    VTiger::PipeLine::Entity.where(kind: 'Lead').each do |v_client|
      data = JSON.parse(v_client.data)
      u_client = Upwork::Client.find_by(upwork_id: data['cf_leads_upworkid'])

      next if u_client.present?

      puts "founded: #{u_client.upwork_id}"
    end
  end
end
