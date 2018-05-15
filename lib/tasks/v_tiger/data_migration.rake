namespace :v_tiger do
  desc 'Send data to the new server'
  task data_migration: :environment do
    fields = {
      'Lead' => {
        'active_assignments_count' => 'cf_leads_upworkactiveassignmentscount',
        'avg_hourly_jobs_rate' => 'cf_leads_upworkavghourlyjobsrate',
        'cf_894' => 'cf_leads_technologies',
        'cf_898' => 'cf_leads_upworkid',
        'cf_906' => 'cf_leads_facebook',
        'cf_908' => 'cf_leads_linkdin',
        'cf_910' => 'cf_leads_skype',
        'cf_912' => 'cf_leads_upworkcontractdate',
        'cf_918' => 'cf_leads_upworkhourscount',
        'cf_928' => 'cf_leads_upworktotalcharges',
        'cf_930' => 'cf_leads_upworktotalassignments',
        'cf_932' => 'cf_leads_upworkactiveassignmentscount',
        'cf_934' => 'cf_leads_upworkopencount',
        'cf_936' => 'cf_leads_upworkscore',
        'cf_938' => 'cf_leads_upworkavghourlyjobsrate',
        'city' => 'city',
        'code' => 'code',
        'company' => 'company',
        'contract_date' => 'cf_leads_upworkcontractdate',
        'country' => 'country',
        'description' => 'description',
        'designation' => 'designation',
        'email' => 'email',
        'fax' => 'fax',
        'feedback_count' => 'cf_leads_upworkfeedbackcount',
        'filled_count' => 'cf_leads_upworkfilledcount',
        'firstname' => 'firstname',
        'hours_count' => 'cf_leads_upworkhourscount',
        'industry' => 'industry',
        'lane' => 'lane',
        'lastname' => 'lastname',
        'leadstatus' => 'leadstatus',
        'mobile' => 'mobile',
        'open_count' => 'cf_leads_upworkopencount',
        'phone' => 'phone',
        'pobox' => 'pobox',
        'posted_count' => 'cf_leads_upworkpostedcount',
        'salutationtype' => 'salutationtype',
        'state' => 'state',
        'website' => 'website'
      },
      'Contact' => {
        'birthday' => 'birthday',
        'cf_1057' => 'cf_contacts_linkdin',
        'cf_1059' => 'cf_contacts_blog',
        'department' => 'department',
        'description' => 'description',
        'email' => 'email',
        'fax' => 'fax',
        'fb_url' => 'cf_contacts_facebook',
        'firstname' => 'firstname',
        'homephone' => 'homephone',
        'imagename' => 'imagename',
        'lastname' => 'lastname',
        'mailingcity' => 'mailingcity',
        'mailingcountry' => 'mailingcountry',
        'mailingpobox' => 'mailingpobox',
        'mailingstate' => 'mailingstate',
        'mailingstreet' => 'mailingstreet',
        'mailingzip' => 'mailingzip',
        'mobile' => 'mobile',
        'notify_owner' => 'notify_owner',
        'othercity' => 'othercity',
        'othercountry' => 'othercountry',
        'otherpobox' => 'otherpobox',
        'otherstate' => 'otherstate',
        'otherstreet' => 'otherstreet',
        'otherzip' => 'otherzip',
        'phone' => 'phone',
        'portal' => 'portal',
        'support_end_date' => 'support_end_date',
        'support_start_date' => 'support_start_date',
        'tw_url' => 'cf_contacts_twitter',
        'vk_url' => 'cf_contacts_vk'
      }
    }

    entities = [VTiger::PipeLine::Entity.where(vtiger_to_id: nil).first]

    bar = ProgressBar.create(
      total: entities.count,
      title: "Upload Entities data",
      format: "%t: %b\u{15E7}%i %p%% %a",
      progress_mark: ' ',
      remainder_mark: "\u{FF65}"
    )

    crm = VTiger::Crm.find_by(name: 'New Version')
    bot = VTiger::Api::Bot.new(crm.api_url, crm.email, crm.access_key)
    bot.authorize!

    entities.each do |entity|
      binding.pry
      # cf_leads_techtest
      entity_data = JSON.parse(entity.data)

      new_data = {}
      fields[entity.kind].each { |from, to| new_data[to] = entity_data[from] }
      new_data['lastname'] = 'none' if new_data['lastname'].empty?
      new_data['contacttype'] = 'Lead' if entity.kind == 'Contact'

      response = bot.create(entity.kind.pluralize, new_data)

      if response['success']
        entity.update(crm_to: crm, vtiger_to_id: response['result']['id'])
      end

      bar.increment
    end
  end
end
