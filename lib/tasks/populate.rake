namespace :db do
  desc "erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Location, Event].each(&:delete_all)
    
    100.times do
      temp_location = Location.create(:name => Faker::Company.name, :full_address => Faker:: Address.street_address + " " + Faker::Address.zip_code)
      
     end
  end
end