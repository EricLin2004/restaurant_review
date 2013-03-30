require 'sqlite3'
require 'singleton'
require 'debugger'
require './chef'
require './restaurant'
require './critic'
require './model'

class RestaurantDB < SQLite3::Database
	include Singleton

	def initialize
		super("restaurants.db")
		self.results_as_hash = true
		self.type_translation = true
	end
end

#p Restaurant.find_by_id(1)
#p Restaurant.find_by_id(1).average_review_score
#puts Restaurant.all
#puts Chef.find_by_id(2).coworkers
#puts Chef.find_by_id(1).reviews
#puts Critic.find_by_id(2).unreviewed_restaurants
#puts Restaurant.top_restaurants

#Chef.new({:id => nil, :first_name => 'Test', :last_name => 'Test2', :mentor => 0}).save