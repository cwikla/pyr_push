class CreateTgpPushGroups < ActiveRecord::Migration
  def change
    create_table :tgp_push_groups do |t|
      t.timestamps
      t.timestamp :deleted_at
      t.string  :name, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_active, :default => true, :null => false
    end

    add_index :tgp_push_groups, [:name, :user_id], :unique => true
  end
end
