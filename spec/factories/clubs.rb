FactoryBot.define do

  factory :club, class: 'Club' do 
    # association :student, factory: :student

    student { FactoryBot.build(:student) }
    club_name { "CODE GEEKS" }
    # club_logo { Rails.root.join('images', 'ER_Events.png').open }
  end

  factory :club1, class: 'Club' do 
    # association :student, factory: :student

    student { FactoryBot.create(:student4) }
    club_name { "TITAN GEEKS" }
    club_logo { Rails.root.join('images', 'ER_Events.png').open }
  
  end

  factory :club2, class: 'Club' do 
    # association :student, factory: :student

    student { FactoryBot.build(:student2) }
    club_name { "MONKEYS" }
    club_logo { Rails.root.join('images', 'ER_Events.png').open }
  end


end