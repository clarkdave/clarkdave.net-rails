class AddTaglineToWorks < ActiveRecord::Migration
  def change
    add_column :works, :tagline, :string
  end
end
