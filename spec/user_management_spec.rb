require 'spec_helper'
require_relative '../helpers/session'

include SessionHelpers

feature "User signs up" do

	#Tests that check the UI should be seperate from tests that check
	#what we have in the database
	#The reason is that you should test one thing at a time
	#whereas by mixing the two you text both business logic and views

	scenario "when being a new user visiting the site" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, luke@example.com")
		expect(User.first.email).to eq("luke@example.com")
		# save_and_open_page
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Password does not match the confirmation")
	end

	scenario "with an email that is already registeres" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect{ sign_up }.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

end