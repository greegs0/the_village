class AddMissingIndexes < ActiveRecord::Migration[7.1]
  def change
    # Index pour les requêtes fréquentes sur events
    add_index :events, :date unless index_exists?(:events, :date)
    add_index :events, :category unless index_exists?(:events, :category)

    # Index pour les requêtes fréquentes sur family_events
    add_index :family_events, :start_date unless index_exists?(:family_events, :start_date)

    # Index composite pour les tâches (filtrage par famille et statut)
    add_index :tasks, [:family_id, :status] unless index_exists?(:tasks, [:family_id, :status])
    add_index :tasks, [:family_id, :target_date] unless index_exists?(:tasks, [:family_id, :target_date])
  end
end
