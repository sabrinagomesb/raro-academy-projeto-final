FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { Faker::IDNumber.brazilian_cpf }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8, special_characters: true) }
    password_confirmation { password }

    trait :admin do
      role { :admin }
    end

    trait :free do
      role { :free }
    end

    trait :premium do
      role { :premium }
    end
  end

  factory :user_confirmed, parent: :user do
    confirmed_at { Time.zone.now }
  end
end
