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

	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

	require './lib/link' #this needs to be done after datamapper is initialised

	#after declaring your models you should finalize them
	DataMapper.finalize

	#However, the database tables don't exist yet. Let's tell datamapper to create them
	DataMapper.auto_upgrade!

	get '/' do
		@links = Link.all		
		erb :index
	end

	post '/links' do
		url = params["url"]
		title = params["title"]
		Link.create(:url => url, :title => title)
		redirect to('/')
	end

end