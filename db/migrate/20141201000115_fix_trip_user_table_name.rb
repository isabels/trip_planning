class FixTripUserTableName < ActiveRecord::Migration
  def change
 	rename_table(:trips_users, :trip_users)

  end
end
