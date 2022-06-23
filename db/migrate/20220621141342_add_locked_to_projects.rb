class AddLockedToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :locked_at, :datetime
  end
end
