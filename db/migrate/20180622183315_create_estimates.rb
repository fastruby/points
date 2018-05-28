class CreateEstimates < ActiveRecord::Migration[5.1]
  def change
    create_table :estimates do |t|
      t.integer :best_case_points
      t.integer :worst_case_points
      t.integer :user_id
      t.integer :story_id

      t.timestamps
    end
  end
end
