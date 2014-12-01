class Trip < ActiveRecord::Base
	has_many :trips_users
	has_many :items
end