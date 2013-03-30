require './restaurant_review'
require 'debugger'

class Model

	def self.table_name
		raise NotImplementedError
	end

	def self.find_by_id(id)
    sql = <<-SQL
      SELECT *
        FROM '#{table_name}'
       WHERE id = ?
    SQL
    
    self.class.new(RestaurantDB.instance.execute(sql, id).first)
	end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
        FROM '#{table_name}'
       WHERE name = ?
    SQL
    
    self.new(RestaurantDB.instance.execute(sql, fname).first)
  end

	def self.all
    sql = <<-SQL
      SELECT *
        FROM '#{table_name}'
    SQL
    
    RestaurantDB.instance.execute(sql, id) {|hash| self.new(hash)}
	end

  attr_reader :id

  def initialize(options = {})
    options = options.each_with_object({}) {|(key,value), hash| hash[key.to_s] = value}

    @id = options['id']

    column_names.each do |column_name|
      self.send("#{column_name}=", options[column_name.to_s])
    end
  end

  def column_values
    column_names.map { |name| self.send(column_name) }
  end

  def save
    debugger
    if @id.nil?
      column_names_string = column_names.join(", ")
      question_marks = Array.new(column_names.count, '?').join(", ")

      sql = <<-SQL
        INSERT INTO '#{table_name}' '(#{column_names_string})'
             VALUES '(#{question_marks})'
      SQL

      RestaurantDB.instance.execute(sql, *column_values)
      @id = RestaurantDB.instance.last_insert_row_id
    else
      sets = column_names.map do |column_name|
        "#{column_name} = ?"
      end

      sets.join(", ")

      sql = <<-SQL
        UPDATE '#{table_name}'
           SET '#{sets}'
         WHERE id = ?
      SQL

      RestaurantDB.instance.execute(sql, *column_values, id)
    end
  end

	private

	def self.attr_accessible(*column_names)
    @column_names = column_names.map { |column_name| column_name }

    @column_names.each do |column_name|
      attr_accessor column_name
    end
	end

  def self.column_names
    @column_names
  end

  def self.column_names
    @column_names
  end
  
  def column_names
    self.class.column_names
  end
  
  def table_name
    self.class.table_name
  end
end