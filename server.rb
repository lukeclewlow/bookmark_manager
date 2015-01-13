require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

#we're telling datamapper to use a postgres database to localhost. The name will be "bookmark-manager"