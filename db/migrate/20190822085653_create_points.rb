class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.boolean :genkyo, default: false # 現況
      t.boolean :sukima, default: false # 隙間
      t.boolean :ware, default: false # 割れ
      t.boolean :kake, default: false # 欠け
      t.boolean :amimejyo, default: false # 網目状
      t.boolean :zencho, default: false # 全長      
      t.boolean :sokuten, default: false  # 測点
      t.boolean :crack, default: false  # クラック
      t.boolean :tile, default: false #タイル
      t.boolean :kire, default: false #切れ
      t.boolean :uki, default: false  #浮き
      t.boolean :suhon, default: false  # 数本
      t.boolean :zenshu, default: false #全周
      t.boolean :suichokukeisya, default: false #垂直傾斜
      t.boolean :chirigire, default: false  #チリ切れ
      t.boolean :cross, default: false  #クロス
      t.boolean :meji, default: false #目地
      t.boolean :tategu, default: false #建具
      t.boolean :tasu, default: false  #多数
      t.boolean :kakusyo, default: false  #各所
      t.boolean :suiheikeisya, default: false #水平傾斜
      t.integer :wide
      t.integer :height
      t.integer :length
      t.string :comment #フリー入力欄
      t.string :image1, default: nil   #写真
      t.string :image2, default: nil   #写真
      t.string :image3, default: nil   #写真
      
      t.references :survey, foreign_key: true

      t.timestamps
    end
  end
end
