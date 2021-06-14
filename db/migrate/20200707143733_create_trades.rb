class CreateTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :trades, id: :uuid do |t|
      t.string :external_id, null: false
      t.references :user, type: :uuid
      t.string :state
      t.timestamps
    end
    add_index :trades, [:external_id, :user_id]
    add_index :trades, :state
  end
end
