FactoryBot.define do 
  factory :event, class: 'Event' do

    club { FactoryBot.build(:club) }
    event_name { Faker::Name.name }
    event_desc { "Faker::Lorem.text" }  
    event_image { Rails.root.join('public', 'icon.png').open }
    event_venue { Faker::Lorem.word }
    event_time { Faker::Time.forward(days: 5, period: :morning) } 
    event_date { Faker::Date.forward(days: 5) } 
    event_deadline { Faker::Time.forward(days: 10, period: :evening) } 

  end
end