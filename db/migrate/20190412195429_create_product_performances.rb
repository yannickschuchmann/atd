class CreateProductPerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :product_performances do |t|
      t.references :keyword, foreign_key: true, index: true
      t.references :product, foreign_key: true, index: true
      t.decimal :click_through_rate, precision: 5, scale: 2
      t.decimal :conversion_rate, precision: 5, scale: 2
      t.date :valued_at

      t.timestamps
    end

    add_index :product_performances, :valued_at
  end
end
