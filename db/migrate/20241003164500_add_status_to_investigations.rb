class AddStatusToInvestigations < ActiveRecord::Migration[5.0]
  def change
    add_column :investigations, :status, :string
  end
end
