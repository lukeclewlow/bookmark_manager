require 'spec_helper'

feature "User signs up" do

	#Tests that check the UI should be seperate from tests that check
	#what we have in the database
	#The reason is that you should test one thing at a time
	#whereas by mixing the two you text both business logic and views

	scenario "when being a new user visiting the site" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, luke@example.com")
		expect(User.first.email).to eq("luke@example.com")
	end

	def sign_up(email = "luke@example.com", password = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end

end