class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :pass
      t.string :salt

      t.timestamps
    end
  end
end
