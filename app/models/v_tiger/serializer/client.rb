module VTiger
  module Serializer
    class Client
      CLIENT_FIELTS = {
        'cf_leads_upworkactiveassignmentscount' => :active_assignments_count,
        'cf_leads_upworkavghourlyjobsrate' => :avg_hourly_jobs_rate,
        'cf_leads_upworkcity' => :city,
        'cf_leads_upworkcontractdate' => :contract_date,
        'cf_leads_upworkcountry' => :country,
        'cf_leads_upworkdescription' => :description,
        'cf_leads_upworkfeedbackcount' => :feedback_count,
        'cf_leads_upworkfilledcount' => :filled_count,
        'cf_leads_upworkhourscount' => :hours_count,
        'cf_leads_upworkname' => :name,
        'cf_leads_upworkopencount' => :open_count,
        'cf_leads_upworkpostedcount' => :posted_count,
        'cf_leads_upworkscore' => :score,
        'cf_leads_upworkstate' => :state,
        'cf_leads_upworktotalassignments' => :total_assignments,
        'cf_leads_upworktotalcharges' => :total_charges,
        'cf_leads_upworktotaljobswithhires' => :total_jobs_with_hires,
        'cf_leads_upworkid' => :upwork_id,
        'cf_leads_upworkurl' => :url,
        'cf_leads_upworkworldregion' => :world_region,
        'lastname' => :name,
        'city' => :city,
        'country' => :country
      }.freeze

      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def serialize!
        CLIENT_FIELTS.map { |f, v| [f, client.send(v) ] }.to_h
      end
    end
  end
end
