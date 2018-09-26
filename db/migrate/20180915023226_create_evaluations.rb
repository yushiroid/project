class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.string :topic_id, null: false
      t.string :user_id, null: false
      t.integer :evaluation, null: false

      t.timestamps
    end
    add_index  :evaluations, [:topic_id, :user_id], unique: true
  end
end
