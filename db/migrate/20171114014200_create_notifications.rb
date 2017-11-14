class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :notifiable_id
      t.string :notifiable_type
      t.datetime :read_at
      t.integer :actor_id
      t.integer :recipient_id
      t.string :action

      t.timestamps
    end
  end
end
