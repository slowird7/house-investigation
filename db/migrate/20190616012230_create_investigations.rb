class CreateInvestigations < ActiveRecord::Migration[5.0]
  def change
    create_table :investigations do |t|
      t.string :content   # 調査内容
      t.string :construction_name   # 工事名
      t.string :construction_display_name1   # 工事名
      t.string :construction_display_name2   # 工事名
      t.string :builder   # 施工者
      t.string :place   # 調査場所
      
      t.string :investigator_pre_survey  # 調査機関
      t.string :investigator_ongoing_survey  # 調査機関
      t.string :investigator_after_survey  # 調査機関
      
      # 調査開始日
      t.date :start_pre_survey, default: nil
      t.date :start_ongoing_survey, default: nil
      t.date :start_after_survey, default: nil
      # 調査終了日
      t.date :stop_pre_survey, default: nil
      t.date :stop_ongoing_survey, default: nil
      t.date :stop_after_survey, default: nil
      
      # 調査コード
      t.string :code
      
      # パスワード
      t.string :password

      t.timestamps
    end
  end
end