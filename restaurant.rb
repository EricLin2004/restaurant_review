class Restaurant
attr_reader :id

	def self.find_by_id(id)
		sql = <<-SQL 
			SELECT *
			FROM restaurants
			WHERE id = ?
		SQL

		Restaurant.new(RestaurantDB.instance.execute(sql, id).first)
	end

	def self.find_by_name(name)
		sql = <<-SQL
			SELECT *
			FROM restaurants
			WHERE name = ?
		SQL

		Restaurant.new(RestaurantDB.instance.execute(sql, name).first)
	end

	def self.by_neighbourhood(neigh)
		sql = <<-SQL
			SELECT *
			FROM restaurants
			WHERE neighbourhood = ?
		SQL

		Restaurant.new(RestaurantDB.instance.execute(sql, neigh).first)
	end

	def self.all
		sql = <<-SQL
			SELECT *
			FROM restaurants
		SQL

		RestaurantDB.instance.execute(sql).map {|hash| Restaurant.new(hash)}
	end

	def self.top_restaurants(n)
		sql = <<-SQL
			SELECT restaurants.*, AVG(score) as ave_score
			  FROM restaurants
			  JOIN reviews
		  	  ON reviews.restaurant_id = restaurants.id
	  GROUP BY restaurants.id
	  ORDER BY AVG(score) DESC
	     LIMIT ?
		SQL

		RestaurantDB.instance.execute(sql, n).map {|hash| Restaurant.new(hash)}
	end

	def self.highly_reviewed_restaurants(min_reviews)
		sql = <<-SQL
			SELECT restaurants.*
			  FROM reviews
			  JOIN restaurants
			    ON reviews.restaurant_id = restaurants.id
		GROUP BY restaurant_id
			HAVING COUNT(reviews.id) >= ?
		SQL

		RestaurantDB.instance.execute(sql, min_reviews).map {|hash| Restaurant.new(hash)}
	end

	def initialize(hash)
		@id = hash['id']
		@name = hash['name']
		@neighbourhood = hash['neighbourhood']
		@cuisine = hash['cuisine']
	end

	def reviews
		sql = <<-SQL
			SELECT reviews.*
			FROM reviews
			JOIN restaurants
			ON reviews.restaurant_id = ?
		SQL

		RestaurantDB.instance.execute(sql, id).map {|hash| Review.new(hash)}
	end

	def average_review_score
		sql = <<-SQL
			SELECT AVG(scores) avg_score
			  FROM (
				  SELECT reviews.score scores
				    FROM reviews
			 			LEFT OUTER JOIN restaurants
				      ON reviews.restaurant_id = restaurants.id
				   WHERE restaurants.id = ?
				)
		SQL

		RestaurantDB.instance.execute(sql, id)
	end
end