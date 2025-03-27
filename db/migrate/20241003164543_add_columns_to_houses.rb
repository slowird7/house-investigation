class AddColumnsToHouses < ActiveRecord::Migration[5.0]
  def change
    add_column :houses, :end_pre_survey_day, :date, default: nil
    add_column :houses, :end_ongoing_survey_day, :date, default: nil
    add_column :houses, :end_after_survey_day, :date, default: nil
  end
end
