class CreateCoursesNews < ActiveRecord::Migration[5.2]
  def change
    create_table :courses_news do |t|
      t.references :course, foreign_key: {on_delete: :cascade, on_update: :cascade}
      t.references :news, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.index [:course_id, :news_id], unique: true
    end
  end
end
