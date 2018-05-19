class Upwork::Job < ApplicationRecord
  belongs_to :client, required: false
  belongs_to :category
  belongs_to :subcategory
  has_and_belongs_to_many :skills

  enum slack_state: [:not_notified, :skipped, :notifying, :notified]
  enum parsing_state: [
    :expecting_opening_uid, :fetching_opening_uid, :error_fetching_opening_uid,
    :expecting_client_info, :fetching_client_info, :error_fetching_client_info,
    :processed
  ]

  def set_parsing_error(description, state)
    update(parsing_error_description: description, parsing_state: state)
  end
end
