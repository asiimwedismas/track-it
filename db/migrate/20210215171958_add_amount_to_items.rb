class AddAmountToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :amount, :integer, null: false
  end
end
