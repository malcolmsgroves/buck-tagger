class CreateCounties < ActiveRecord::Migration[5.1]
  def change
    create_table :counties do |t|

      t.timestamps
    end

    create_table :deers do |t|
      t.integer :weight
      t.string :season
      t.string :sex
      t.integer :points
    end
  end
end
