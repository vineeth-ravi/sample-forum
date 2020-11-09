class CreateUserFollowDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_follow_details do |t|
      t.integer :user_id
      t.integer :following_user_id

      t.timestamps
    end
  end
end
