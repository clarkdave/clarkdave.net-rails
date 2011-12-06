class AddPublishedAndSnippetToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :snippet, :text
    add_column :posts, :published, :boolean
  end
end
