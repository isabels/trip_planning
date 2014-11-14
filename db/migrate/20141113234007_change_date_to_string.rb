class ChangeDateToString < ActiveRecord::Migration
  def change
  	change_column(:trips, :date, :string)
  end
end
