class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end

    add_index :rooms, :slug, unique: true
  end
end
