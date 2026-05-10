# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development?
  puts "Seeding base users..."

  roles = User.roles.keys

  roles.each do |role|
    email = "#{role}@zenrunner.com"
    
    User.find_or_create_by!(email: email) do |user|
      user.name = "#{role.capitalize} User"
      user.password = "password123"
      user.password_confirmation = "password123"
      user.role = role
    end
  end

  puts "Users seeded successfully!"
end
