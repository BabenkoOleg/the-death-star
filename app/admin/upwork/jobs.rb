ActiveAdmin.register Upwork::Job do
  menu label: 'Jobs', parent: 'Upwork', priority: 3

  permit_params :title, :status, :pricing, :duration, :workload, :opening_uid, :description, :url, :upwork_id,
                :parsing_error_description, :slack_state, :parsing_state, :budget, :created_date, :client_id,
                :category_id, :subcategory_id

  config.sort_order = 'id_asc'

  member_action :open_url, method: :get do
    redirect_to resource.url
  end

  filter :client, as: :select
  filter :category, as: :select
  filter :subcategory, as: :select
  filter :skills, as: :select
  filter :slack_state, as: :select, collection: Upwork::Job.slack_states
  filter :parsing_state, as: :select, collection: Upwork::Job.parsing_states

  index do
    selectable_column
    id_column
    column :title do |job|
      link_to job.title[0..40], admin_upwork_job_path(job)
    end
    column :client do |job|
      if job.client.present?
        link_to job.client.name, admin_upwork_client_path(job.client)
      end
    end
    column :parsing_state
    column :slack_state
    actions defaults: true do |job|
      link_to 'On Upwork', job.url, class: 'member_link', target: '_blank'
    end
  end

  show do
    attributes_table do
      row(:title)
      row(:status)
      row(:pricing)
      row(:duration)
      row(:workload)
      row(:opening_uid)
      row(:description)
      row('On Upwork') { |job| link_to(job.url, job.url, target: '_blank') }
      row(:budget)
      row(:client_id)
      row(:category) { |job| link_to job.category.title, admin_upwork_category_path(job.category) }
      row(:subcategory) { |job| link_to job.subcategory.title, admin_upwork_subcategory_path(job.subcategory) }
      row(:slack_state)
      row(:parsing_state)
      row(:parsing_error_description)
      row(:created_date)
    end
  end
end
