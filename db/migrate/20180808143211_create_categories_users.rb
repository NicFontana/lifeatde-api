class CreateCategoriesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_users do |t|
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :category, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
      t.index [:user_id, :category_id]
    end
  end
end
