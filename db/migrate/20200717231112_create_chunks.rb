class CreateChunks < ActiveRecord::Migration[6.0]
  def change
    create_table :chunks do |t|
      t.integer :x
      t.integer :y
      t.integer :mine_count, default: 3300
      t.integer :size, default: 128
      t.column :bin_mine_positions, "bit(16384)"
      t.column :bin_opened_positions, "bit(16384)"
      t.boolean :active

      t.timestamps
    end
  end
end
