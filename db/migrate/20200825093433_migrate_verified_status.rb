class MigrateVerifiedStatus < ActiveRecord::Migration[6.0]
  def change
    User.find_each do |user|
      user.verify!(:mobile_number) if user.verified
    end
  end
end
