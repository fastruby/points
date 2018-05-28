class AddPositionToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :position, :integer
  end
end
