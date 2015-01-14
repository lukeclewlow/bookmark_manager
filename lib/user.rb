require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String
	#this will store both the password and the salt
	#its text and not string because string holds 50
	#characters by dfault and ist not enough for hash and salt
	property :password_digest, Text

	#when assigned password, we dont store directly
	#we generate a passwor digest and save it in the database
	#This digest, provided by Bcrypt, has both the 
	#password hash and the salt. We save it to the database 
	#instead of the plain password for security reasons.

	def password=(password)
		self.password_digest = BCrypt::Password.create(password)
	end


end