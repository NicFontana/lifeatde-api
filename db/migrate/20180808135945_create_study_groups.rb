class CreateStudyGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :study_groups do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :user, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :course, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
