class MakeFamilyOptionalOnUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :family_id, true
  end
end
