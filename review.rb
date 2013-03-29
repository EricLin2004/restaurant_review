class Review
	def self.find_by_id(id)
		sql = <<-SQL
			SELECT *
			  FROM reviews
			 WHERE id = ?
		SQL

		Review.new(RestaurantDB.instance.execute(sql, id).first)
	end

	def initialize(hash)
		@id = hash['id']
		@review = hash['review']
		@score = hash['score']
		@critic_id = hash['critic_id']
		@restaurant_id = hash['restaurant_id']
	end
	
end