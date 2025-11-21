class CreateFamilyEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :family_events do |t|
      t.string :title
      t.string :event_type
      t.text :description
      t.date :start_date
      t.date :end_date
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
