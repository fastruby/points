class AddVersionJumpToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :version_jump
  end
end
