class CreateUnavailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :unavailabilities do |t|
      t.references :family, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :reason

      t.timestamps
    end
  end
end
