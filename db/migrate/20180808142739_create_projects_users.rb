class CreateProjectsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :projects_users do |t|
      t.references :project, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.boolean :is_admin

      t.timestamps
      t.index [:user_id, :project_id]
    end
  end
end
