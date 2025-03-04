FactoryBot.define do
  factory :student, class: 'Student' do
    name { "DUMMY" }  
    email { "dummy2@gmail.com" }
    password { "Dummy@123" }
    role { "user" }
  end

  factory :student1, class: 'Student' do
    name { "JOKER" }  
    email { "joker2@gmail.com" }
    password { "Joker@123" }
    role { "user" }
  end

  factory :student2, class: 'Student' do
    name { "MONKEY" }  
    email { "monkey2@gmail.com" }
    password { "Monkey@123" }
    role { "user" }
  end

  factory :student3, class: 'Student' do
    name { "HARRY" }  
    email { "harry2@gmail.com" }
    password { "Harry@123" }
    role { "user" }
  end

  factory :student4, class: 'Student' do
    name { Faker::Name.name_with_middle }  
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, mix_case: true, special_characters: true)}
    role { %i[user club_head admin].sample   }
  end
end