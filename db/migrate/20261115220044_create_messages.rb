class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :room, null: false, foreign_key: true
      t.string :author_name, null: false
      t.text :body, null: false
      t.string :kind, null: false, default: "human"
      t.bigint :in_reply_to_id

      t.timestamps
    end

    add_foreign_key :messages, :messages, column: :in_reply_to_id
    add_index :messages, :in_reply_to_id, unique: true
    add_index :messages, [:room_id, :created_at, :id]
  end
end
