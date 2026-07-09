class ResetPassword < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reset_password_token, :string, default: nil
    add_column :users, :reset_password_token_expires_at, :datetime, default: nil

    add_index :users, :reset_password_token, unique: true
  end
end
