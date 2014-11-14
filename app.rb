# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require
require './models/Item'
require './models/User'
require './models/Trip'

# enable :sessions #lets you use sessions hash, will send back set-cookie header

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter => 'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end
#authentication bullshit
# get '/login' do #for submitting anuthentication
# 	erb :login
# end

# post '/login' do
# 	require "json"
# end

get '/' do
	@users = User.all.order(:name)
	@trips = Trip.all.order(:date)
	erb :home
end

# get '/' do
# 	@users = User.all.order(:name)
# 	erb :user_list
# end

post '/create_user' do
	User.create(params)
	redirect '/'
end

post '/create_trip' do
	Trip.create(params)
	redirect'/'
end

# post '/create_user' do
# 	User.create(params)
# 	redirect '/'
# end

post '/delete_user/:id' do
	User.find_by(id: params[:id]).destroy
	#have to do something about deleting user's items
	redirect '/'
end

post '/delete_trip/:id' do
	Trip.find_by(id: params[:id]).destroy
	#have to do something about deleting trip's items
	redirect '/'
end

# post '/delete_user/:id' do
# 	User.find_by(id: params[:id]).destroy
# 	redirect '/'
# end

get '/users/:id' do
	@user = User.find_by(id: params[:id])
	@trips = Trip.where(user_id: @user.id)
	erb user
end

get '/trips/:id' do
	@users = User.where(trip_id: params[:id])
	@items = Item.where(trip_id: params[:id])
	erb trip
end

# get '/users/:id' do
# 	@user = User.find_by(id: params[:id])
# 	# find(:first, :conditions => "user_name = '#{user_name}' AND password = '#{password}'")
# 	@tasks = TodoItem.where(user_id: @user.id) 
# 	erb :item_list
# end

post '/trips/:id/create_item' do
	@trip = Trip.find(params[:id])
	#figure out how to get which parameters into the right things!
	redirect "/trips/#{@trip.id.to_s}"
end

# post '/:user/create_item' do
# 	@user = User.find(params[:user])
# 	TodoItem.create(user: @user, description: params[:description], due_date: params[:due_date])
# 	redirect "/users/#{@user.id.to_s}"
# end

post '/delete_item/:trip/:item' do
	@trip = Trip.find(params[:trip])
	Item.find_by(id: params[:item]).destroy
	redirect "/trips/#{@trip.id.to_s}"
end

# post '/delete/:user/:item' do
# 	@user = User.find(params[:user])
# 	TodoItem.find_by(id: params[:item]).destroy
# 	redirect "/users/#{@user.id.to_s}"
# end

