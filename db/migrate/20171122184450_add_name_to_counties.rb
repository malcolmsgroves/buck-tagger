class AddNameToCounties < ActiveRecord::Migration[5.1]
  def change
    add_column :counties, :name, :string
  end
end
