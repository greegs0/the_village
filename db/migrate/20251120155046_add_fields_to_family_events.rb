class AddFieldsToFamilyEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :family_events, :time, :time
    add_column :family_events, :location, :string
    add_column :family_events, :assigned_to, :string
    add_column :family_events, :event_icon, :string
    add_column :family_events, :badge_class, :string
    add_column :family_events, :reminders_enabled, :boolean, default: false
  end
end
