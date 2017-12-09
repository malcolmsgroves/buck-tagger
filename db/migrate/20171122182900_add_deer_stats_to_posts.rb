class AddDeerStatsToPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :deers do |t|
      t.integer "weight"
      t.string "season"
      t.string "sex"
      t.integer "points"
      t.bigint "post_id"
      t.index ["post_id"], name: "index_deers_on_post_id"
      t.timestamps
    end
  end
end
