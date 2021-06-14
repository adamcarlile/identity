FactoryBot.define do
  factory :user do
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    email         { Faker::Internet.email name: [first_name, last_name].join(' ') }
    mobile_number { Faker::Base.numerify("+44#{Faker::PhoneNumber.cell_phone}".gsub(" ", "")) }

    trait :verified do
      after(:create) do |user, _|
        user.verify!(:email)
        user.verify!(:mobile_number)
      end
    end
  end
end
