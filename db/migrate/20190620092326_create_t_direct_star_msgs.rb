class CreateTDirectStarMsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_direct_star_msgs do |t|
      t.integer :userid
      t.integer :directmsgid

      t.timestamps
    end
    add_index :t_direct_star_msgs, :userid
    add_index :t_direct_star_msgs, :directmsgid
    add_index :t_direct_star_msgs, [:userid, :directmsgid], unique: true
  end
end
