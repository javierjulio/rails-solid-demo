class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :room, null: false, foreign_key: true
      t.string :author_name
      t.text :body
      t.string :kind
      t.integer :in_reply_to_id

      t.timestamps
    end
  end
end
