FactoryBot.define do

  factory :register, class: 'Register' do
    name { Faker::Name.name_with_middle }
    branch { "Computer" }
    year { %i[FE SE TE BE].sample }

    student { FactoryBot.build(:student) }
    event { FactoryBot.build(:event) }
  end

  factory :register_without_event_existing, class: 'Register' do
    name { Faker::Name.name_with_middle }
    branch { "Computer" }
    year { %i[FE SE TE BE].sample }

    student { FactoryBot.build(:student) }
  end

  factory :registering_when_link_is_absent, class: 'Register' do
    name { Faker::Name.name_with_middle }
    branch { "Computer" }
    year { %i[FE SE TE BE].sample }

    student { FactoryBot.build(:student) }
    event { FactoryBot.build(:event_with_link_absent) }
  end
end