FactoryBot.define do
  sequence(:external_id)

  factory :trade do
    association :user, factory: :user
    external_id
  end
end
