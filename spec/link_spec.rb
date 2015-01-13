require 'spec_helper'

describe Link do
	
	context 'Demonstration of how datamapper works' do

		it 'should be created and then retrieved from the db' do
			#In the beginning db is empty, no links
			expect(Link.count).to eq(0)
			#this creates it in the database, so its stored on the disk
			Link.create(title: 'Makers Academy',
									url: 'http://www.makersacademy.com/')
			#we ask the database how many links we have
			expect(Link.count).to eq(1)
			#Let's get the first and only link from the database
			link = Link.first
			#Now it has all the properties it was saved with
			expect(link.url).to eq('http://www.makersacademy.com/')
			expect(link.title).to eq('Makers Academy')
			#If we want to we can destroy it
			link.destroy
			#so now we have no links in the db
			expect(Link.count).to eq(0)
		end

	end

end