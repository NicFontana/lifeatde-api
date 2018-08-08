class CreateProjectCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :project_categories do |t|
      t.references :project, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :category, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
