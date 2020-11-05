class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :p_id
      t.integer :user_id
      t.text :content
      t.string :category
      t.integer :like_count
      t.integer :dislike_count
      t.integer :reply_count
      t.integer :parent_id
      t.timestamp :created_at
      t.timestamp :modified_at
    end
  end
end
