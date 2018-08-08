class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :course, foreign_key: {on_delete: :nullify, on_update: :cascade}

      t.timestamps
    end
  end
end
