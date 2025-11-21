class ChangeTaskAssigneeToPointToPeople < ActiveRecord::Migration[7.1]
  def change
    # Supprimer l'ancienne foreign key vers users
    remove_foreign_key :tasks, column: :assignee_id if foreign_key_exists?(:tasks, column: :assignee_id)

    # Supprimer l'ancien index
    remove_index :tasks, :assignee_id if index_exists?(:tasks, :assignee_id)

    # Ajouter la nouvelle foreign key vers people
    add_foreign_key :tasks, :people, column: :assignee_id

    # Ajouter le nouvel index
    add_index :tasks, :assignee_id
  end
end
