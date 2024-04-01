class CreateTGroupMentionMsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_group_mention_msgs do |t|
      t.integer :userid
      t.integer :groupmsgid

      t.timestamps
    end
    add_index :t_group_mention_msgs, :userid
    add_index :t_group_mention_msgs, :groupmsgid
    add_index :t_group_mention_msgs, [:userid, :groupmsgid], unique: true
  end
end
