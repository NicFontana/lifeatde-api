class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :bio
      t.date :birthday
      t.string :phone
      t.references :course, foreign_key: {on_delete: :nullify, on_update: :cascade}
      t.index :email, unique: true

      t.timestamps
    end
  end
end
