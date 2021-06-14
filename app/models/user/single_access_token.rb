class User::SingleAccessToken < ApplicationRecord
  include ActiveModel::Transitions
  self.table_name_prefix = 'user_'

  belongs_to :user
  has_secure_token

  scope :available,   -> { where(state: :unused, created_at:  Rails.application.config.user.single_access_token_duration.ago...Time.now) }
  scope :unavailable, -> { where.not(id: available) }
  scope :for,         -> (intent) { where(intent: intent)}

  state_machine auto_scopes: true do
    state :unused
    state :consumed
    state :revoked

    event :consume do
      transitions to: :consumed, from: :unused
    end

    event :revoke do
      transitions to: :revoked, from: :unused
    end
  end

  def to_param
    token
  end

  def expired?
    Rails.application.config.single_access_token_duration.ago >= created_at
  end
end
