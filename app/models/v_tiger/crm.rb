class VTiger::Crm < ApplicationRecord
  has_many :exported_entities, class_name: 'VTiger::PipeLine::Entity', foreign_key: 'crm_from_id'
  has_many :imported_entities, class_name: 'VTiger::PipeLine::Entity', foreign_key: 'crm_to_id'
end
