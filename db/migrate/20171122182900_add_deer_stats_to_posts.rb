class AddDeerStatsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :deers, :county, foreign_key: true
    add_reference :deers, :post, foreign_key: true
  end
end
