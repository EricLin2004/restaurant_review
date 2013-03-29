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
				    JOIN restaurants
				      ON reviews.restaurant_id = restaurants.id
				   WHERE restaurants.id = ?
					 UNION
					SELECT 0 scores
					  FROM reviews
					  JOIN restaurants
					    ON reviews.restaurant_id = restaurants.id
					 WHERE restaurants.id = ? AND reviews.score IS NULL
				)
		SQL

		RestaurantDB.instance.execute(sql, id, id)
	end

end