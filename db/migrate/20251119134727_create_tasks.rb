class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :status
      t.date :created_date
      t.date :target_date
      t.string :description
      t.string :time
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_reference :tasks, :assignee, foreign_key: { to_table: :users }
  end
end
