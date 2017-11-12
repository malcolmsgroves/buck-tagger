class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id,     foreign_key: true
      t.integer :followed_id,    foreign_key: true
      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
  end
end
