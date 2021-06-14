FactoryBot.define do
  factory :doorkeeper_application, class: 'Doorkeeper::Application' do
    name         { Faker::Company.name }
    uid          { SecureRandom.uuid }
    secret       { SecureRandom.uuid }
    confidential { true }
    redirect_uri { Faker::Internet.url.gsub('http', 'https') }
    scopes       { 2.times.map { Doorkeeper.configuration.scopes.to_a.sample }.uniq.join(' ') }
  end
end
