class AddUserIdToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :user_id, :integer, null: false
    add_foreign_key :items, :users
  end
end
