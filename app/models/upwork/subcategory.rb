class Upwork::Subcategory < ApplicationRecord
  belongs_to :category
  has_many :jobs
  has_many :search_queries
end
