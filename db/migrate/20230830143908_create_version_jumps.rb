class CreateVersionJumps < ActiveRecord::Migration[7.0]
  def change
    create_table :version_jumps do |t|
      t.string :technology
      t.string :initial_version
      t.string :target_version

      t.timestamps
    end
  end
end
