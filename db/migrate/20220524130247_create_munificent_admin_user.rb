class CreateMunificentAdminUser < ActiveRecord::Migration[7.0]
  def change
    create_table :munificent_admin_users do |t|
      t.string :email_address, null: false, index: { unique: true }
      t.string :name

      # Permissions
      t.boolean :data_entry, default: false, null: false
      t.boolean :full_access, default: false, null: false
      t.boolean :manages_users, default: false, null: false
      t.boolean :support, default: false, null: false

      # 2FA
      t.datetime :last_otp_at
      t.string :otp_secret

      # Authlogic::ActsAsAuthentic::Password
      t.string    :crypted_password
      t.string    :password_salt

      # Authlogic::ActsAsAuthentic::PersistenceToken
      t.string    :persistence_token
      t.index     :persistence_token, unique: true

      # Authlogic::ActsAsAuthentic::SingleAccessToken
      t.string    :single_access_token
      t.index     :single_access_token, unique: true

      # Authlogic::ActsAsAuthentic::PerishableToken
      t.string    :perishable_token
      t.index     :perishable_token, unique: true

      # See "Magic Columns" in Authlogic::Session::Base
      t.integer   :login_count, default: 0, null: false
      t.integer   :failed_login_count, default: 0, null: false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip

      # See "Magic States" in Authlogic::Session::Base
      t.boolean   :active, default: false
      t.boolean   :approved, default: false
      t.boolean   :confirmed, default: false

      t.timestamps
    end
  end
end
