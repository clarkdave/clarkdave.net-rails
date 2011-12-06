class AddImageColumnsToWork < ActiveRecord::Migration
  def change
  	remove_column :works, :image
  	remove_column :works, :thumbnail
  	add_column :works, :techs, :string
  	add_column :works, :image_file_name, :string
  	add_column :works, :image_content_type, :string
  	add_column :works, :image_file_size, :integer
  	add_column :works, :image_updated_at, :datetime
  end
end
