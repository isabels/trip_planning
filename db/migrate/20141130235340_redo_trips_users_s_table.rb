class RedoTripsUsersSTable < ActiveRecord::Migration
  def change
  	drop_table :trips_users

  	create_table :trips_users do |t|
      t.integer :user_id
      t.integer :trip_id
    end

  end
end
