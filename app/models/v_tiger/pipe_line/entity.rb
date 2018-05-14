class VTiger::PipeLine::Entity < ApplicationRecord
  belongs_to :crm_from, class_name: 'VTiger::Crm', foreign_key: 'crm_from_id'
  belongs_to :crm_to, class_name: 'VTiger::Crm', foreign_key: 'crm_to_id', required: false

  enum state: [:fetched, :migrated]
end
