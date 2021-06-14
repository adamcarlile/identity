# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email
      t.string :mobile_number
      t.string :encrypted_password

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :mobile_number,        unique: true
  end
end
