class AddPublishedToWorks < ActiveRecord::Migration
  def change
    add_column :works, :published, :boolean, :default => false
  end
end
