class AddColumnsToDamages < ActiveRecord::Migration[5.0]
  def change
    add_column :damages, :amimejyo2, :boolean, default: false
    add_column :damages, :zencho2, :boolean, default: false
    add_column :damages, :zenshu2, :boolean, default: false
    add_column :damages, :wide2, :float
    add_column :damages, :length2, :float
    add_column :damages, :width2, :float
    add_column :damages, :height2, :float
  end
end
