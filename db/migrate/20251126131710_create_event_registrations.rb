class CreateEventRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :event_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    # Un utilisateur ne peut s'inscrire qu'une fois à un événement
    add_index :event_registrations, [:user_id, :event_id], unique: true
  end
end
