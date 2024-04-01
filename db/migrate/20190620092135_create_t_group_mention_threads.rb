class CreateTGroupMentionThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :t_group_mention_threads do |t|
      t.integer :userid
      t.integer :groupthreadid

      t.timestamps
    end
    add_index :t_group_mention_threads, :userid
    add_index :t_group_mention_threads, :groupthreadid
    add_index :t_group_mention_threads, [:userid, :groupthreadid], unique: true
  end
end
