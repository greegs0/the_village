class AddZipcodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :zipcode, :string
  end
end
