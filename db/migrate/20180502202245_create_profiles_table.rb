class CreateProfilesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
    t.integer :birthday
    t.integer :about_me
    t.string :avatar
    t.datetime :created_at
    t.datetime :updated_at
    end
  end
end
