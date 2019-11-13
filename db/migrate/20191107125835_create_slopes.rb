class CreateSlopes < ActiveRecord::Migration[5.0]
  def change
    create_table :slopes do |t|
      t.string :survey_type # pre、ongoing after

      t.integer :position_wb, default: 0 # 0：左、1：左上、2：上、3：右上、4：右、5：右下、6：下、7：左下      
      t.boolean :suichokukeisya, default: false #垂直傾斜
      t.boolean :suiheikeisya, default: false #水平傾斜
      t.float :east
      t.float :west
      t.float :north
      t.float :south
      t.string :comment #フリー入力欄
      t.string :image1, default: nil   #写真
      t.string :image2, default: nil   #写真
      t.string :image3, default: nil   #写真
      t.string :image_url

      t.references :keisya, foreign_key: true

      t.timestamps
    end
  end
end