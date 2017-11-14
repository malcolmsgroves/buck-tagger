class AddLikeableTypeToLikes < ActiveRecord::Migration[5.1]
  def change
    add_column :likes, :likeable_type, :string
    add_index :likes, :likeable_type
  end


end
