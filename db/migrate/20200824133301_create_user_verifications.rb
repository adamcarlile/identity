class CreateUserVerifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_verifications, id: :uuid do |t|
      t.references  :user, type: :uuid
      t.string      :credential, null: false
      t.timestamps
    end

    add_index :user_verifications, :credential, order: { verified_at: :desc }
  end
end
