class CreateUserActions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_actions do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :action

      t.timestamps
    end
  end
end
