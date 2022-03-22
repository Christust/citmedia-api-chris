class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :title
      t.string :name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :user_type
      t.references :clinic
      t.timestamps
    end
  end
end
