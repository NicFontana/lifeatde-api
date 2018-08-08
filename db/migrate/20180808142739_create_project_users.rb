class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :project, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
