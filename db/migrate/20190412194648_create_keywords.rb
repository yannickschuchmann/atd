class CreateKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.string :department, index: true
      t.string :value, index: true

      t.timestamps
    end

    add_index :keywords, [:value, :department]
  end
end
