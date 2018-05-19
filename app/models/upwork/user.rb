class Upwork::User < ApplicationRecord
  include Upwork::Occupied

  def username
    email.split('@').first.capitalize
  end
end
