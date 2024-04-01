class CreateTGroupMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :t_group_messages do |t|
      t.string :groupmsg
      t.references :m_channel, foreign_key: true
      t.references :m_user, foreign_key: true

      t.timestamps
    end
  end
end
