class CreateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :houses do |t|
      t.string :house_name
      t.string :prefectures
      t.string :city
      t.string :block
      t.string :owner
      t.references :investigation, foreign_key: true

      t.timestamps
    end
  end
end
