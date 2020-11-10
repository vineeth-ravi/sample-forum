class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email_id
      t.string :password
      t.string :image_id
      t.timestamp :created_at
    end
  end
end
