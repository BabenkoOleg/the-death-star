class Upwork::User < ApplicationRecord
  def username
    email.split('@').first.capitalize
  end
end
