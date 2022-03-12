class AddSearchIndexToStories < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :stories, :searchable, using: :gin, algorithm: :concurrently
  end
end
