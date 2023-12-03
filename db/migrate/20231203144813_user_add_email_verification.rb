class UserAddEmailVerification < ActiveRecord::Migration[7.0]
  def change
    add_column :users, 'email', 'string'
    add_column :users, 'verified', 'boolean'
    add_column :users, 'confirmation_code', 'string'
  end
end
