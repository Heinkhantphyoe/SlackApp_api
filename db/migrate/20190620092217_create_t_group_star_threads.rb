class CreateTGroupStarThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :t_group_star_threads do |t|
      t.integer :userid
      t.integer :groupthreadid

      t.timestamps
    end
    add_index :t_group_star_threads, :userid
    add_index :t_group_star_threads, :groupthreadid
    add_index :t_group_star_threads, [:userid, :groupthreadid], unique: true
  end
end
