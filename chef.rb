require 'sqlite3'

class Chef

	def initialize(variables)
    @first_name = variables[:first_name]
    @last_name = variables[:last_name]
    @birthday = variables[:birthday]
    @email = variables[:email]
    @phone = variables[:phone]
    @created_at = variables[:created_at]
    @updated_at = variables[:updated_at]
  end

  def self.create_table
    Chef.db.execute(
      <<-SQL
      CREATE TABLE chefs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name VARCHAR(64) NOT NULL,
        last_name VARCHAR(64) NOT NULL,
        birthday DATE NOT NULL,
        email VARCHAR(64) NOT NULL,
        phone VARCHAR(64) NOT NULL,
        created_at DATETIME NOT NULL,
        updated_at DATETIME NOT NULL
        );
    SQL
    )
  end

  def self.seed
    Chef.db.execute(
      <<-SQL
      INSERT INTO chefs
      (first_name, last_name, birthday, email, phone, created_at, updated_at)
      VALUES
      ('Ferran', 'Adriá', '1985-02-09', 'ferran.adria@elbulli.com', '42381093238', DATETIME('now'), DATETIME('now')),
      ('Gordon', 'Ramsay','1966-06-22', 'Ramsay.gordon@gmail.com',  '42381093238', DATETIME('now'), DATETIME('now')),
      ('Oliver', 'Jamie', '1975-05-30', 'Jamie.oliver@gmail.com',   '42381093238', DATETIME('now'), DATETIME('now')),
      ('Child',  'Julia', '1912-12-21', 'Julia.child@gmail.com',    '42381093238', DATETIME('now'), DATETIME('now')),
      ('Batali', 'Mario', '1960-08-19', 'Mario.batali@gmail.com',   '42381093238', DATETIME('now'), DATETIME('now'));
      SQL
      )
  end


  def self.select_all
    chefs_info = Chef.db.execute(
      <<-SQL
      select * from chefs
      SQL
      )
    self.array(chefs_info)
  end
    # chefs_info.each_with_index do |key, value|
    #   p Chef.new( )
    # end
  def self.array(chefs_info)
    chefs_array = []
    
    chefs_info.each do |chef|
      chefs_array << Chef.new(first_name:chef[1], last_name:chef[2],birthday:chef[3], email:chef[4], phone:chef[5], created_at:chef[6], updated_at:chef[7])
    end
    chefs_array
  end


  def self.select_where(column, value)
    chefs_info = Chef.db.execute(
      <<-SQL
      select * from chefs
      where #{column} = '#{value}'
      SQL
    )
    self.array(chefs_info)
  end

  def save
    Chef.db.execute(
      <<-SQL 
      INSERT INTO chefs (first_name, last_name, birthday, email, phone, created_at, updated_at)
      VALUES ('#{@first_name}', '#{@last_name}', '#{@birthday}', '#{@email}', '#{@phone}', '#{@created_at}', '#{@updated_at}')
      SQL
    )
  end

  def self.delete(column, value)
    Chef.db.execute(
      <<-SQL
      DELETE FROM chefs
    WHERE #{column} = '#{value}'
      SQL
    )
  end

  private

    def self.db
      @@db ||= SQLite3::Database.new("chefs.db")
    end
end

chefsito = Chef.new(first_name:'Daniel', last_name:'Garcia', birthday:'1986-10-28', email:'dany@gmail.com', phone:'45986531575', created_at:Time.now, updated_at:Time.now)
# chefsito.save
# puts chefsito.select_all
# Chef.select_all

p Chef.select_where("first_name", "Daniel")
p Chef.delete("last_name", "Julia")