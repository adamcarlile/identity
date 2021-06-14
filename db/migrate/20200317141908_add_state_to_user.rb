class AddStateToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :state, :string
    add_index :users, :state
  end
end
