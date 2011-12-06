class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.text :description
      t.text :features
      t.string :url
      t.date :completed
      t.string :image
      t.string :thumbnail

      t.timestamps
    end
  end
end
