class CreateCategoriesProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_projects do |t|
      t.references :project, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :category, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
      t.index [:project_id, :category_id]
    end
  end
end
