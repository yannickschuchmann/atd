class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :asin
      t.string :title

      t.timestamps
    end

    add_index :products, :asin
  end
end
