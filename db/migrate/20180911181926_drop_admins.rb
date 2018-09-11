class DropAdmins < ActiveRecord::Migration[5.1]
  def change
     drop_table :admins
  end
end
