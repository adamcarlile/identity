class RegistrationForm < FormObject

  attribute :first_name, String
  attribute :last_name, String

  attribute :mobile_number, String
  attribute :email, String

  validates :first_name, :last_name, :mobile_number, :email, presence: true
  validates :email, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :mobile_number, \
    phone: { possible: true, types: [:mobile], countries: [:gb]  }

  def mobile_number
    Phonable.parse super
  end

end
