class RemoveForeignKeyFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :likes, :posts
  end
end
