class CreateUserTripAndItem < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :name
  	end

  	create_table :trips do |t|
  		t.string :name
  		t.date :date
  	end

  	create_table :users_trips, id: false do |t|
      t.belongs_to :user
      t.belongs_to :trip
    end

  	create_table :items do |t|
  		t.string :name
  		t.binary :packed
  		t.integer :trip_id
  		t.integer :user_id
  	end
  end
end
