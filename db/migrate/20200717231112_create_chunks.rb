class CreateChunks < ActiveRecord::Migration[6.0]
  def change
    create_table :chunks do |t|
      t.integer :x
      t.integer :y
      t.binary :bombs
      t.binary :opened
      t.boolean :active

      t.timestamps
    end
  end
end
