class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :survey_type # pre、ongoing after

      t.integer :position_wb, default: 0 # 0：左上、1：上、2：右上、3：右下、4：下、5：左下
      # 水準手簿の入力値
      t.float :ouro_bs, default: 0.0
      t.float :ouro_fs, default: 0.0
      t.float :fukuro_bs, default: 0.0
      t.float :fukuro_fs, default: 0.0
      t.float :hyoko, default: 0.0
      t.string :comment #フリー入力欄
      t.string :image1, default: nil   #写真
      t.string :image2, default: nil   #写真
      t.string :image3, default: nil   #写真
      t.string :image_url
      
      t.references :point, foreign_key: true

      t.timestamps
    end
  end
end
