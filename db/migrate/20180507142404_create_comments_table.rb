class CreateCommentsTable < ActiveRecord::Migration[5.2]
  def change
         create_table :comments do |c|
      c.integer :user_id
      c.integer :post_id
      c.string :comment
      c.string :image
      c.datetime :created_at
      c.datetime :updated_at
    end
  end
end
