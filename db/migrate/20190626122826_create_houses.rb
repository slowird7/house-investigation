class CreateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :houses do |t|
      t.integer :house_number
      t.string :house_name  # 家屋名（居住者名）
#      t.string :post_code # 郵便番号      
      t.string :prefectures # 都道府県
      t.string :city  # 市区町村
      t.string :block # 番地
      t.string :resident_phone_number  # 居住者電話番号
      t.string :owner_name_ruby     # 所有者名（フリガナ）
      t.string :owner_name  # 所有者名
#      t.string :owner_post_code # 郵便番号
      t.string :owner_prefectures # 都道府県
      t.string :owner_city  # 市区町村
      t.string :owner_block # 番地
      t.string :owner_phone_number  # 所有者電話番号
      t.string :construction  # 構造
      t.string :floors  # 階数
      t.string :area  #延面積
      t.date :completion_date # 建物が完成した日
      t.string :use # 用途
      # 承諾書サイン（所有者）
      t.string :sign_pre_survey, default: nil   #事前
      t.string :sign_ongoing_survey, default: nil   #事中
      t.string :sign_after_survey, default: nil   #事後
      # 承諾書サイン（居住者）
      t.string :kyojyusya_sign_pre_survey, default: nil   #事前
      t.string :kyojyusya_sign_ongoing_survey, default: nil   #事中
      t.string :kyojyusya_sign_after_survey, default: nil   #事後
      
      # 事前、事中、事後調査
#      t.boolean :pre_survey, default: false
#      t.boolean :ongoing_survey, default: false
#      t.boolean :after_survey, default: false
      # 建物概要（概査、精査）
      t.string :overview_pre_survey
      t.string :overview_ongoing_survey
      t.string :overview_after_survey
      # 調査範囲
      t.string :range_pre_survey
      t.string :range_ongoing_survey
      t.string :range_after_survey
      # 調査開始日
      t.date :pre_survey_day, default: nil
      t.date :ongoing_survey_day, default: nil
      t.date :after_survey_day, default: nil
      # 調査終了日
      t.date :end_pre_survey_day, default: nil
      t.date :end_ongoing_survey_day, default: nil
      t.date :end_after_survey_day, default: nil

      # 並び替えON/OFFフラグ
#      t.boolean :sort_sonsyos, default: false
#      t.boolean :sort_keisyas, default: false
#      t.boolean :sort_points, default: false
      
      t.references :investigation, foreign_key: true

      t.timestamps
    end
  end
end