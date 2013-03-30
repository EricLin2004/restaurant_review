require 'debugger'
require './model'

class Chef < Model

	def self.table_name
		'chefs'
	end
	# def self.find_by_name(fname, lname)
	# 	sql = <<-SQL 
	# 		SELECT *
	# 		  FROM chefs
	# 		 WHERE first_name = ?
	# 		   AND last_name = ?
	# 	SQL

	# 	Chef.new(RestaurantDB.instance.execute(sql, fname, lname).first)
	# end

	# def self.find_by_id(id)
	# 	sql = <<-SQL
	# 		SELECT *
	# 		  FROM chefs
	# 		 WHERE id = ?
	# 	SQL

	# 	Chef.new(RestaurantDB.instance.execute(sql, id).first)
	# end

	def initialize(hash)
		@id = hash['id']
		@first_name = hash['first_name']
		@last_name = hash['last_name']
		@mentor = hash['mentor']
	end

	def proteges
		sql = <<-SQL
			SELECT *
			  FROM chefs
			 WHERE mentor = ?
		SQL

		RestaurantDB.instance.execute(sql, id).map {|hash| Chef.new(hash)}
	end

	def num_proteges
		sql = <<-SQL
			SELECT COUNT(*) num_proteges
			  FROM chefs
			 WHERE mentor = ?
		SQL

		RestaurantDB.instance.execute(sql, id)[0]['num_proteges']
	end

	def coworkers
		sql = <<-SQL
			SELECT DISTINCT chef_b.*
				FROM chefs chef_a
				JOIN chef_tenure tenure_a
				  ON chef_a.id = tenure_a.chef_id
				JOIN chef_tenure tenure_b
				  ON tenure_b.restaurant_id = tenure_a.restaurant_id
				JOIN chefs chef_b
				  ON chef_b.id = tenure_b.chef_id
			 WHERE chef_b.id != ? AND chef_a.id = ?
			   AND tenure_a.start_date < tenure_b.end_date
			   AND tenure_b.start_date < tenure_a.end_date
		SQL
		#debugger
		RestaurantDB.instance.execute(sql, id, id).map {|hash| Chef.new(hash)}
	end

	def reviews
		sql = <<-SQL
			SELECT reviews.*
				FROM chef_tenure
				JOIN reviews
					ON chef_tenure.restaurant_id = reviews.restaurant_id
			 WHERE chef_tenure.chef_id = ?
			   AND chef_tenure.head_chef = 1
		SQL

		RestaurantDB.instance.execute(sql, id)
	end

end