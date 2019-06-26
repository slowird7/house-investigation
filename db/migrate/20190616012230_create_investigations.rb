class CreateInvestigations < ActiveRecord::Migration[5.0]
  def change
    create_table :investigations do |t|
      t.string :content   # 調査内容
      t.string :construction_name   # 工事名
      t.string :builder   # 施工者
      t.string :investigator  # 調査機関
      t.string :place   # 調査場所

      t.timestamps
    end
  end
end