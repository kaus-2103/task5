class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :identifier
      t.string :name
      t.string :address
      t.string :phone
      t.string :email

      t.timestamps
    end

    add_index :users, :identifier, unique: true 
  end
end
