class ChangeLikeToLikeable < ActiveRecord::Migration[5.1]
  def change
    rename_column :likes, :post_id, :likeable_id
  end
end
