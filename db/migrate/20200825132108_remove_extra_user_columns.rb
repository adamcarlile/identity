class RemoveExtraUserColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :verified
    remove_column :users, :postcode
  end
end
