require 'data_mapper'

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

