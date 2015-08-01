class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :fname
    	t.string :lname
    	t.string :email
    	t.string :access_level
    	t.string :type
    	t.string :password_digest
    	t.timestamps
    end
  end
end
