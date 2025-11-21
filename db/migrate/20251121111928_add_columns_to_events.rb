class AddColumnsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :max_participations, :integer
    add_column :events, :participations_count, :integer
    add_column :events, :category, :string
  end
end
