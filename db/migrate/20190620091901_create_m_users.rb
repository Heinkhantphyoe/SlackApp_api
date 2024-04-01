class CreateMUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :m_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :profile_image
      t.string :remember_digest
      t.boolean :active_status
      t.boolean :admin
      t.boolean :member_status

      t.timestamps
    end
  end
end
