class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :content, null: false
      t.string :image
      t.timestamps
    end
  end
end
