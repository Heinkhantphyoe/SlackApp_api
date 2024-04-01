class CreateTUserWorkspaces < ActiveRecord::Migration[5.2]
  def change
    create_table :t_user_workspaces do |t|
      t.integer :userid
      t.integer :workspaceid

      t.timestamps
    end
    add_index :t_user_workspaces, :userid
    add_index :t_user_workspaces, :workspaceid
    add_index :t_user_workspaces, [:userid, :workspaceid], unique: true
  end
end
