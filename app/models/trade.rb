class Trade < ApplicationRecord
  include ActiveModel::Transitions

  validates :external_id, uniqueness: { scope: :user }, presence: true
  belongs_to :user

  state_machine auto_scopes: true do
    state :pending
    state :active
    state :suspended

    event :activate do
      transitions to: :active, from: [:pending, :suspended]
    end

    event :suspend do
      transitions to: :suspended, from: [:active, :pending]
    end
  end

  scope :available, -> { where(state: [:pending, :active]) }

  def as_json
    {
      id: external_id,
      state: state
    }
  end

end
