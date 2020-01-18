class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.integer :number # 測点
      t.string :room_name
      t.string :room_name_other
      t.references :house, foreign_key: true

      t.timestamps
    end
  end
end