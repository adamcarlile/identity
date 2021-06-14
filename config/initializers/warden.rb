class Warden::DeserializationError < StandardError; end

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :one_time_password, :single_access_token
  manager.intercept_401 = false
  manager.failure_app   = Rails.application.routes
end

Rails.configuration.to_prepare do
  # Setup Session Serialization
  class Warden::SessionSerializer
    def serialize(record)
      [record.class.name, record.id]
    end

    def deserialize(keys)
      klass, id = keys
      user = klass.constantize
      return false unless user.exists?(id) 
      user.find(id)
    end
  end

  Warden::Strategies.add(:one_time_password, OneTimePasswordStrategy)
  Warden::Strategies.add(:single_access_token, SingleAccessTokenStrategy)
end
