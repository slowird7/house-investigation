class CreateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :houses do |t|
      t.string :house_name  # 家屋名（居住者名）
#      t.string :post_code # 郵便番号      
      t.string :prefectures # 都道府県
      t.string :city  # 市区町村
      t.string :block # 番地
      t.string :resident_phone_number  # 居住者電話番号
      t.string :owner_name  # 所有者名
#      t.string :owner_post_code # 郵便番号
      t.string :owner_prefectures # 都道府県
      t.string :owner_city  # 市区町村
      t.string :owner_block # 番地
      t.string :owner_phone_number  # 所有者電話番号
      t.string :construction  # 構造
      t.string :floors  # 階数
      t.string :area  #延面積
      t.string :use # 用途
      
      t.references :investigation, foreign_key: true

      t.timestamps
    end
  end
end