class Upwork::Category < ApplicationRecord
  has_many :jobs
  has_many :subcategories
  has_many :search_queries
end
