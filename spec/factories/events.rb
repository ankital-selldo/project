FactoryBot.define do 
  factory :event, class: 'Event' do
    club { FactoryBot.create(:club1) }

    event_name { "Tech Conference 2025" }

    event_desc { "A large conference for tech enthusiasts, featuring keynote speakers, workshops, and networking opportunities." }

    event_image { Rails.root.join('public', 'icon.png').open }  

    event_venue { "Tech Park Auditorium" }

    event_time { "09:30:00" } 

    event_date { "2025-03-15" } 

    event_deadline { "2025-03-20 17:00:00" }  

    event_register_link { ["https://techconference2025.com/register, "] } 
  end
end
