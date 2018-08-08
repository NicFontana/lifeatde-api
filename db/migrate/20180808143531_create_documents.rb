class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.string :path, null: false
      t.references :project, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
