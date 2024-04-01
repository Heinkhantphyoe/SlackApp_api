class CreateMChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :m_channels do |t|
      t.string :channel_name
      t.boolean :channel_status
      t.references :m_workspace, foreign_key: true

      t.timestamps
    end
    add_index :m_channels, [:m_workspace_id, :created_at]
  end
end
