class VTiger::UploadClientsJob < ApplicationJob
  queue_as :vtiger_upload_clients

  def perform(ids)
    api = VTiger::Api.new
    api.authorize!

    clients = Upwork::Client.where(id: ids)

    clients.each do |client|
      client.uploading!

      client_response = api.query("select * from Leads where cf_leads_upworkid = '#{client.upwork_id}';")
      client_data = JSON.parse(client_response.body)
      next if client_data['success'] && client_data['result'].any?

      contact_response = api.query("select * from Contacts where cf_contacts_upworkid = '#{client.upwork_id}';")
      contact_data = JSON.parse(contact_response.body)
      next if contact_data['success'] && contact_data['result'].any?

      data = VTiger::Serializer::Client.new(client).serialize!

      response = api.create('Leads', data)

      if response['success'].present? && response['result']['id'].present?
        client.update(vtiger_id: response['result']['id'])
        client.uploaded!
      end
    end
  end
end
