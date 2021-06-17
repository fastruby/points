class AddRealScoreToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :real_score, :integer, default: nil
  end
end
