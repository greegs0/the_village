class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.string :file_type
      t.integer :file_size
      t.references :folder, null: false, foreign_key: true
      t.references :family, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_favorite, default: false

      t.timestamps
    end
  end
end
