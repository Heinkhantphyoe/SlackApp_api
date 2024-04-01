class CreateTDirectThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :t_direct_threads do |t|
      t.string :directthreadmsg
      t.boolean :read_status
      t.references :t_direct_message, foreign_key: true
      t.references :m_user, foreign_key: true

      t.timestamps
    end
    add_index :t_direct_threads, [:t_direct_message_id, :created_at]
    add_index :t_direct_threads, [:m_user_id, :created_at]
  end
end
