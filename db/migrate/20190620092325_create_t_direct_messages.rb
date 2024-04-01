class CreateTDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :t_direct_messages do |t|
      t.string :directmsg
      t.boolean :read_status
      t.integer :send_user_id
      t.integer :receive_user_id

      t.timestamps
    end
    add_index :t_direct_messages, :send_user_id
    add_index :t_direct_messages, :receive_user_id
    add_index :t_direct_messages, [:send_user_id, :receive_user_id]
  end
end
