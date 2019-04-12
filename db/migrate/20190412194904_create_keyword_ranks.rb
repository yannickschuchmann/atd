class CreateKeywordRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :keyword_ranks do |t|
      t.references :keyword, foreign_key: true, index: true
      t.integer :position
      t.date :valued_at
      
      t.timestamps
    end

    add_index :keyword_ranks, :valued_at
    add_index :keyword_ranks, :position
  end
end
