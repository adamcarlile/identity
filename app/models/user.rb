# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::Transitions
  include PgSearch::Model

  scope :ordered, ->() { order(last_name: :asc, first_name: :asc) }
  scope :by_mobile_or_email, -> (mobile_number:, email:) do
    where("mobile_number = ? OR email = ?", Phonable.parse(mobile_number), email)
  end

  pg_search_scope :search,
    against: [:first_name, :last_name, :email],
    using: {
      tsearch: {
        dictionary: "english",
        prefix: true
      }
    }

  has_one_time_password counter_based: true
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :invitations, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :verifications, dependent: :destroy
  has_many :single_access_tokens, dependent: :destroy

  before_save do
    self.mobile_number = Phonable.parse mobile_number
  end

  state_machine auto_scopes: true do
    state :pending
    state :active
    state :suspended

    event :activate do
      transitions to: :active, from: :pending
    end

    event :suspend do
      transitions to: :suspended, from: [:active, :pending]
    end
  end

  def otp_current?
    otp_expires_at > Time.zone.now
  end

  def verified?(credential)
    verifications.where(credential: credential).exists?
  end

  def verify!(credential)
    verifications.create(credential: credential)
  end

  def revoke_invitations
    invitations.available.each(&:revoke!)
  end

  private

  def otp_expires_at
    (otp_created_at + 5.minutes).iso8601
  end

end
