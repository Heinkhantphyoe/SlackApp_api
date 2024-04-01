class CreateTDirectStarThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :t_direct_star_threads do |t|
      t.integer :userid
      t.integer :directthreadid

      t.timestamps
    end
    add_index :t_direct_star_threads, :userid
    add_index :t_direct_star_threads, :directthreadid
    add_index :t_direct_star_threads, [:userid, :directthreadid], unique: true
  end
end
