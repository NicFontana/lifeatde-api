class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :results
      t.references :project_status, foreign_key: {on_delete: :nullify, on_update: :cascade}

      t.timestamps
    end
  end
end
