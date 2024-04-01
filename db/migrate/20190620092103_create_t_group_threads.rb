class CreateTGroupThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :t_group_threads do |t|
      t.string :groupthreadmsg
      t.references :t_group_message, foreign_key: true
      t.references :m_user, foreign_key: true

      t.timestamps
    end
    add_index :t_group_threads, [:t_group_message_id, :created_at]
    add_index :t_group_threads, [:m_user_id, :created_at]
  end
end
