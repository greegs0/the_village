class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :status
      t.date :created_date
      t.date :target_date
      t.string :description
      t.string :time

      t.timestamps
    end
  end
end
