FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    application { }
    expires_in { 2.hours }
    scopes { 'openid' }
  end
end
