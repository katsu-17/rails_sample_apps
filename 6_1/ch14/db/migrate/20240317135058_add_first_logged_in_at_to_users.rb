class AddFirstLoggedInAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_logged_in_at, :datetime
  end
end
