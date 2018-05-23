namespace :v_tiger do
  desc 'Fetch data from the old crm'
  task fetch_data: :environment do
    crm = VTiger::Crm.find_by(name: 'Old Version')

    bot = VTiger::Api::Bot.new(crm.api_url, crm.email, crm.access_key)
    bot.authorize!

    %w[Lead Contact].each do |type|
      response = bot.query("select count(*) from #{type.pluralize};")
      count = JSON.parse(response)['result'][0]['count'].to_i
      pages = (count.to_f / 100.0).ceil

      bar = ProgressBar.create(
        total: pages,
        title: "Fetching #{type.pluralize} data",
        format: "%t: %b\u{15E7}%i %p%% %a",
        progress_mark: ' ',
        remainder_mark: "\u{FF65}"
      )

      pages.times do |page|
        response = bot.query("select * from #{type.pluralize} limit #{page * 100}, 100;")
        fetched_entities = JSON.parse(response)['result']

        break if fetched_entities.empty?

        fetched_entities.each do |fetched_entity|
          entity = VTiger::PipeLine::Entity.find_by(vtiger_from_id: fetched_entity['id'])

          if entity.nil?
            VTiger::PipeLine::Entity.create(
              crm_from: crm,
              kind: type,
              vtiger_from_id: fetched_entity['id'],
              data: fetched_entity.to_json,
              state: :fetched
            )
          end
        end

        bar.increment
      end
    end
  end
end
