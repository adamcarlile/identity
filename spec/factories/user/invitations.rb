FactoryBot.define do
  factory :user_invitation, class: 'User::Invitation' do
    association :user, factory: :user
    association :application, factory: :doorkeeper_application
    confirm_details { false }
    redirect_uri    { Faker::Internet.url }
  end
end
