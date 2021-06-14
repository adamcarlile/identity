class CreateUserInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_invitations, id: :uuid do |t|
      t.references :application, type: :uuid
      t.references :user, type: :uuid
      t.string :redirect_uri
      t.string :state
      t.string :token
      t.boolean :confirm_details, default: false
      t.timestamps
    end
    add_index :user_invitations, :token, unique: true
    add_index :user_invitations, :state
  end
end


