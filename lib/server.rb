require 'data_mapper'
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/partial'

class BookmarkManager < Sinatra::Base

	set :views, Proc.new { File.join(root, '..',"views") }
	set :public_dir, Proc.new{File.join(root, '..', "public")}
  set :public_folder, '/public'


	env = ENV['RACK_ENV'] || 'development'

	#we're telling datamapper to use a postgres database to localhost. 
	#The name will be "bookmark_manager_test" or "bookmark_manager_development"
	#depending on the environment

	# DataMapper::Logger.new($stdout, :debug) #shows logs from server as test runs
	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

	require './lib/link' #this needs to be done after datamapper is initialised
	require './lib/tag'
	require './lib/user.rb'

	#after declaring your models you should finalize them
	DataMapper.finalize

	
	DataMapper.auto_migrate!

	enable :sessions
	set :session_secret, 'super secret'
	use Rack::Flash
	use Rack::MethodOverride

  configure do
    register Sinatra::Partial
  end


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
		@user = User.new
		erb :"users/new"
	end

	post '/users' do
		@user = User.create(:email => params[:email],
											:password => params[:password],
											:password_confirmation => params[:password_confirmation])
		if @user.save
			session[:user_id] = @user.id
			redirect to('/')
		else
			flash.now[:errors] = @user.errors.full_messages
			erb :"users/new"
		end
	end

	get '/sessions/new' do
		erb :"sessions/new"
	end

	post '/sessions' do
		email, password = params[:email], params[:password]
		user = User.authenticate(email, password)
		if user
			session[:user_id] = user.id
			redirect to '/'
		else
			flash[:errors] = ["The email or password is incorrect"]
			erb :"sessions/new"
		end
	end

	delete '/sessions' do
		flash[:notice] = "Good bye!"
		# session.clear
		session[:user_id] = nil
		redirect '/'
	end

	helpers do 

		def current_user
			@current_user ||=User.get(session[:user_id]) if session[:user_id]
		end

	end

end