class AddExtraInfoToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :extra_info, :string
  end
end
