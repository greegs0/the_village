class CreateFolders < ActiveRecord::Migration[7.1]
  def change
    create_table :folders do |t|
      t.string :name, null: false
      t.string :icon
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
