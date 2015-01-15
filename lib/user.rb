require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String, :unique => true, :message => "This email is already taken"
	#this will store both the password and the salt
	#its text and not string because string holds 50
	#characters by dfault and ist not enough for hash and salt
	property :password_digest, Text

	#when assigned password, we dont store directly
	#we generate a passwor digest and save it in the database
	#This digest, provided by Bcrypt, has both the 
	#password hash and the salt. We save it to the database 
	#instead of the plain password for security reasons.

	attr_reader :password
	attr_accessor :password_confirmation

	validates_confirmation_of :password

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		# if this user exists and the password provided matches
	  # the one we have password_digest for, everything's fine
	  #
	  # The Password.new returns an object that overrides the ==
	  # method. Instead of comparing two passwords directly
	  # (which is impossible because we only have a one-way hash)
	  # the == method calculates the candidate password_digest from
	  # the password given and compares it to the password_digest
	  # it was initialised with.
	  # So, to recap: THIS IS NOT A STRING COMPARISON
	  if user && BCrypt::Password.new(user.password_digest) == password
	    # return this user
	    user
	  else
	    nil
	  end
	end



end