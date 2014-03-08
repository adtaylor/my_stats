class CreateAuthorisations < ActiveRecord::Migration
  def change
    create_table :authorisations do |t|
      t.string :secret
      t.string :token
      t.string :user_id
      t.string :uid
      t.string :provider
    end
  end
end
