class RemoveFeaturesFromWorks < ActiveRecord::Migration
  def change
  	remove_column :works, :features
  	add_column :works, :techs, :text
  end
end
