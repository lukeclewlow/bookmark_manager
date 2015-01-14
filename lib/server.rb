require 'data_mapper'
require 'sinatra/base'

class BookmarkManager < Sinatra::Base

	set :views, Proc.new { File.join(root, '..',"views") }
	set :public_dir, Proc.new{File.join(root, '..', "public")}
  set :public_folder, '/public'


	env = ENV['RACK_ENV'] || 'development'

	#we're telling datamapper to use a postgres database to localhost. 
	#The name will be "bookmark_manager_test" or "bookmark_manager_development"
	#depending on the environment

	DataMapper::Logger.new($stdout, :debug)
	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

	require './lib/link' #this needs to be done after datamapper is initialised
	require './lib/tag'
	require './lib/user.rb'

	#after declaring your models you should finalize them
	DataMapper.finalize

	#However, the database tables don't exist yet. Let's tell datamapper to create them
	DataMapper.auto_upgrade!

	enable :sessions
	set :session_secret, 'super secret'

	get '/' do
		@links = Link.all		
		erb :index
	end

	post '/links' do
		url = params["url"]
		title = params["title"]
		tags = params["tags"].split(" ").map do |tag|
			Tag.first_or_create(:text => tag)
		end
		Link.create(:url => url, :title => title, :tags => tags)
		redirect to('/')
	end

	get '/tags/:text' do
		tag = Tag.first(:text => params[:text])
		@links = tag ? tag.links : []
		erb :index
	end

	get '/users/new' do
		erb :"users/new"
	end

	post '/users' do
		user = User.create(:email => params[:email],
								:password => params[:password])
		session[:user_id] = user.id
		redirect to('/')
	end

	helpers do 

		def current_user
			@current_user ||=User.get(session[:user_id]) if session[:user_id]
		end

	end

end