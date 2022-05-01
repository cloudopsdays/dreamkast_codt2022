class AddOrderToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :order, :integer
  end
end