class Upwork::Subcategory < ApplicationRecord
  belongs_to :category
  has_many :jobs
end
