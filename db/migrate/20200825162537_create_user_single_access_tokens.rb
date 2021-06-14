class CreateUserSingleAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :user_single_access_tokens, id: :uuid do |t|
      t.references :user, type: :uuid
      t.string :token, null: false
      t.string :state, null: false
      t.string :intent, null: false
      t.timestamps
    end

    add_index :user_single_access_tokens, :token, unique: true
    add_index :user_single_access_tokens, [:state, :intent]
  end
end
