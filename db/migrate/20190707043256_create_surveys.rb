class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :survey_name  # 事前調査、事中調査、事後調査など
      t.string :overview  # 建物概要（概査、精査）
      t.string :range # 調査範囲
      t.references :house, foreign_key: true

      t.timestamps
    end
  end
end
