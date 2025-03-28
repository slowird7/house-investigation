class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :role  # superuser, admin, operator, outside_operator
      t.string :email
      t.string :user_name
      t.string :password_digest

      t.timestamps
    end
  end
end
