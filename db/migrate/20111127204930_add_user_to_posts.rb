class AddUserToPosts < ActiveRecord::Migration
  def change
  	remove_column :posts, :name
    add_column :posts, :user_id, :integer
  end
end
