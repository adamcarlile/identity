# frozen_string_literal: true

class AddOtpCreatedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :otp_created_at, :datetime, default: -> { 'now()' }
  end
end
