class CreateUserCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_categories do |t|
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :category, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
