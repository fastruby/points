class AddApprovedToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :approved, :boolean, default: nil
  end
end
