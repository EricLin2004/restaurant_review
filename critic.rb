require './review'
require 'debugger'
class Critic

	attr_reader :id

	def self.find_by_screen_name(name)
		sql = <<-SQL
			SELECT *
				FROM critics
			 WHERE screen_name = ?
		SQL

		Critic.new(RestaurantDB.instance.execute(sql, name).first)
	end

	def self.find_by_id(id)
		sql = <<-SQL
			SELECT *
				FROM critics
			 WHERE id = ?
		SQL

		Critic.new(RestaurantDB.instance.execute(sql, id).first)
	end

	def initialize(hash)
		@id = hash['id']
		@screen_name = hash['screen_name']
	end

	def reviews
		sql = <<-SQL
			SELECT *
				FROM critics
				JOIN reviews
					ON critics.id = reviews.critic_id
		SQL

		RestaurantDB.instance.execute(sql).map {|hash| Review.new(hash)}
	end

	def average_review_score
		sql = <<-SQL
			SELECT AVG(scores) avg_score
			FROM (
				SELECT reviews.score scores
					FROM reviews
					LEFT OUTER JOIN critics
						ON critics.id = reviews.critic_id
				 WHERE critic.id = ?
			)
		SQL

		RestaurantDB.instance.execute(sql).first['avg_score']
	end

	def unreviewed_restaurants
		sql = <<-SQL
		  SELECT restaurants.*
		    FROM restaurants
		   WHERE restaurants.id NOT IN (SELECT reviews.restaurant_id
					  FROM critics
			      JOIN reviews
					    ON reviews.critic_id = critics.id
					 WHERE critics.id = ?)
		SQL

		RestaurantDB.instance.execute(sql, id).map {|hash| Restaurant.new(hash)}
	end

end