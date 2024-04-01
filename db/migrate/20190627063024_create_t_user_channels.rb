class CreateTUserChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :t_user_channels do |t|
      t.integer :message_count
      t.string :unread_channel_message
      t.boolean :created_admin
      t.integer :userid
      t.integer :channelid

      t.timestamps
    end
    add_index :t_user_channels, :userid
    add_index :t_user_channels, :channelid
    add_index :t_user_channels, [:userid, :channelid], unique: true
  end
end
