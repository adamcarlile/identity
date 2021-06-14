class User::Invitation < ApplicationRecord
  include ActiveModel::Transitions

  self.table_name_prefix = 'user_'

  belongs_to :application,
    class_name: 'Doorkeeper::Application'

  belongs_to :user

  has_secure_token

  validates :redirect_uri, presence: true

  before_create :revoke_invitations

  scope :unavailable, -> { where.not(state: :available) }

  state_machine auto_scopes: true do
    state :available
    state :consumed
    state :revoked

    event :consume do
      transitions to: :consumed, from: :available
    end

    event :revoke do
      transitions to: :revoked, from: :available
    end
  end

  def to_param
    token
  end

  def confirm_details?
    super || user.mobile_number.blank?
  end

  private

  def revoke_invitations
    user.revoke_invitations
  end

end
