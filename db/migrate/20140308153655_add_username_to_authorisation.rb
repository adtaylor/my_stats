class AddUsernameToAuthorisation < ActiveRecord::Migration
  def change
    add_column :authorisations, :username, :string
  end
end
