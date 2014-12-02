# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require
require './models/Item'
require './models/User'
require './models/Trip'
require './models/TripUser'

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter => 'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

get '/' do
	@users = User.all.order(:name)
	@trips = Trip.all.order(:date)
	erb :main
end

post '/create_user' do
	User.create(name: params[:name])
	redirect '/'
end

post '/create_trip' do
	Trip.create(params)
	redirect'/'
end

post '/delete_user/:id' do
	TripUser.where(user_id: params[:id]).destroy_all
	User.find_by(id: params[:id]).destroy
	#have to do something about deleting user's items
	redirect '/'
end

post '/delete_trip/:id' do
	TripUser.where(trip_id: params[:id]).destroy_all
	Item.where(trip_id: params[:id]).destroy_all #???
	Trip.find_by(id: params[:id]).destroy
	redirect '/'
end

get '/users/:id' do
	@user = User.find_by(id: params[:id])
	@trips = Trip.where(id: TripUser.select(:trip_id).where(user_id: params[:id]))
	erb :user
end

#this is the page with all of the trip's info
get '/trips/:id' do
	@trip = Trip.find(params[:id])
	@users = User.where(id: TripUser.select(:user_id).where(trip_id: params[:id]))
	@items = Item.where(trip_id: params[:id])
	erb :trip
end

#this is the select users to add to trip page
get '/trips/:id/add_user' do
	@trip = Trip.find(params[:id])
	@users = User.where.not(id: TripUser.select(:user_id).where(trip_id: params[:id]))
	erb :select_user
end

#this is the add existing user to a trip from the add users to trip page
get '/add_user_to_trip/:trip_id/:user_id' do
	TripUser.create(trip_id: params[:trip_id], user_id: params[:user_id])
	redirect "/trips/#{params[:trip_id]}"
end

#this is creating an item
post '/trips/:id/create_item' do
	Item.create(name: params[:name], trip_id: params[:id], user_id: 0)
	#figure out how to get which parameters into the right things!
	redirect "/trips/#{@params[:id]}/edit_items"
end

#this is the create user option from the add users to trip page
post '/create_user_with_trip/:trip_id' do
	user = User.create(name: params[:name])
	user
	TripUser.create(trip_id: params[:trip_id], user_id: user.id) #this doesn't work????
	redirect "/trips/#{params[:trip_id]}"
end

#this is the delete user button from the users list on the trip page
post '/delete_user_from_trip/:trip_id/:user_id' do
	TripUser.find_by(user_id: params[:user_id], trip_id: params[:trip_id]).destroy # AND in activerecord
	redirect "/trips/#{params[:trip_id]}"
end

post '/delete_item/:trip/:item' do
	@trip = Trip.find(params[:trip])
	Item.find_by(id: params[:item]).destroy
	redirect "/trips/#{@trip.id}/edit_items"
end

get '/trips/:trip_id/edit_items' do
	@trip = Trip.find(params[:trip_id])
	@items = Item.where(trip_id: params[:trip_id])
	erb :select_items
end

post '/assign_items/:trip_id' do
	items = params[:items]
	items.each do |item|
		Item.find_by(id: item[1]).update(user_id: params[:users])
	end
	redirect "/trips/#{params[:trip_id]}"
end


