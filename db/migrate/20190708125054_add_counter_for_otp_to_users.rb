# frozen_string_literal: true

class AddCounterForOtpToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :otp_counter, :integer, default: 0
  end
end
