class AddCoordinatesToFamilyEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :family_events, :latitude, :decimal, precision: 10, scale: 6
    add_column :family_events, :longitude, :decimal, precision: 10, scale: 6
    add_column :family_events, :address, :string
  end
end
