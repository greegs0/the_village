class CreateFamilyEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :family_events do |t|
      t.references :family, null: false, foreign_key: true
      t.string :title
      t.string :event_type
      t.text :description
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.string :assigned_to
      t.boolean :enable_reminders

      t.timestamps
    end
  end
end
