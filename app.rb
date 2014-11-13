# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require
require './models/Item'
require './models/User'
require './models/Trip'

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter => 'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

# get '/' do
# 	@users = User.all.order(:name)
# 	erb :user_list
# end

# post '/create_user' do
# 	User.create(params)
# 	redirect '/'
# end

# post '/delete_user/:id' do
# 	User.find_by(id: params[:id]).destroy
# 	redirect '/'
# end

# get '/users/:id' do
# 	@user = User.find_by(id: params[:id])
# 	# find(:first, :conditions => "user_name = '#{user_name}' AND password = '#{password}'")
# 	@tasks = TodoItem.where(user_id: @user.id) 
# 	erb :item_list
# end

# post '/:user/create_item' do
# 	@user = User.find(params[:user])
# 	TodoItem.create(user: @user, description: params[:description], due_date: params[:due_date])
# 	redirect "/users/#{@user.id.to_s}"
# end

# post '/delete/:user/:item' do
# 	@user = User.find(params[:user])
# 	TodoItem.find_by(id: params[:item]).destroy
# 	redirect "/users/#{@user.id.to_s}"
# end

