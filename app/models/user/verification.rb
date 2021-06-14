class User::Verification < ApplicationRecord
  self.table_name_prefix = 'user_'

  belongs_to :user

  scope :emails,          -> { where(credentials: 'email') }
  scope :mobile_numbers,  -> { where(credentials: 'mobile_number') }

end
