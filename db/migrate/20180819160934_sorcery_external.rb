class SorceryExternal < ActiveRecord::Migration[5.2]
  def change
    create_table :authentications do |t|
      t.integer :user_id, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true, name: 'ui_authentications_01'
  end
end
