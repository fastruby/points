class AddPositionToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :position, :integer
  end
end
