class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.decimal :price, :precision => 8, :scale => 2
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :course, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
