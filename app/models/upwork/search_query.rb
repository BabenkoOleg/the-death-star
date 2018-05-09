class Upwork::SearchQuery < ApplicationRecord
  JOBS_ON_PAGE = 100

  belongs_to :category, required: false
  belongs_to :subcategory, required: false
  has_and_belongs_to_many :skills

  def return_to_first_page!
    update(page: 0)
  end

  def next_page!
    update(page: page + 1)
  end

  def to_hash
    {}.tap do |query|
      query['q'] = q if q.present?
      query['title'] = title if title.present?
      query['skills'] = skills.map(&:title).join(', ') if skills.any?
      query['title'] = title if title.present?
      query['category2'] = category.title if category.present?
      query['subcategory2'] = subcategory.title if subcategory.present?
      query['paging'] = "#{page * JOBS_ON_PAGE};#{JOBS_ON_PAGE}"
    end
  end
end
