FactoryBot.define do

  factory :register, class: 'Register' do
    name { Faker::Name.name_with_middle }
    branch { "Computer" }
    year { %i[FE SE TE BE].sample }

    student { FactoryBot.create(:student) }
    event { FactoryBot.create(:event) }
  end
end