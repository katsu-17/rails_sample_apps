class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.integer :follower_ids, array: true, default: []
      t.string :follower_name

      t.timestamps
    end
  end
end
