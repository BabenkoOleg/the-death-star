# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Upwork
# ------
#

# Create Fake users
%w[
  nagiki@storiqax.com
  minilanosi@gifto12.com
  doted@bitwhites.top
  powe@aditus.info
  vuvuheseh@ethersportz.info
  docijocevi@gifto12.com
].each do |email|
  next if Upwork::User.where(email: email).exists?

  Upwork::User.create(
    email: email,
    password: 'Akkerman9000#',
    user_agent: 'Mozilla/5.0 (Unknown; Linux) AppleWebKit/538.1 (KHTML, like Gecko) Chrome/v1.0.0 Safari/538.1'
  )

  puts " -- User #{email} created"
end

# Create Search requests
%w[python javascript rails ruby angular].each do |query|
  unless Upwork::SearchQuery.where(q: query).exists?
    sq = Upwork::SearchQuery.create(q: query)
    puts " -- SearchQuery #{sq.q} created"
  end
end

# Admin Panel
# -----------
#

admin_user_email = Rails.application.credentials[Rails.env.to_sym][:admin_user_email]
admin = AdminUser.find_by(email: admin_user_email)

unless admin.present?
  AdminUser.create(
    email: admin_user_email,
    password: Rails.application.credentials[Rails.env.to_sym][:admin_user_password],
    password_confirmation: Rails.application.credentials[Rails.env.to_sym][:admin_user_password],
  )
  puts " -- AdminUser #{admin_user_email} created"
end
