class AddFamilyIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :family, foreign_key: true

    # Mise à jour des tâches existantes pour leur attribuer la famille de leur user
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE tasks
          SET family_id = users.family_id
          FROM users
          WHERE tasks.user_id = users.id
        SQL
      end
    end

    # Rendre family_id obligatoire après la migration des données
    change_column_null :tasks, :family_id, false
  end
end
