class CreateSlopes < ActiveRecord::Migration[5.0]
  def change
    create_table :slopes do |t|
      t.string :survey_type # pre、ongoing after

      t.integer :position_wb, default: 0 # 0：左上、1：上、2：右上、3：右下、4：下、5：左下      
      t.boolean :suichokukeisya, default: false #垂直傾斜
      t.boolean :suiheikeisya, default: false #水平傾斜
      t.float :east
      t.float :west
      t.float :north
      t.float :south
      t.string :comment #フリー入力欄
      
      t.string :image1, default: nil   # オリジナル写真
      t.string :image2, default: nil   # 矢印付き写真
      t.string :image3, default: nil   # ホワイトボード付き写真
      t.string :image_url              # ハッシュ付きホワイトボード等付写真
      t.string :original_image_url     # ハッシュ付きオリジナル写真      

      t.references :keisya, foreign_key: true

      t.timestamps
    end
  end
end