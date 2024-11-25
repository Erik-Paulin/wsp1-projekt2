require 'sqlite3'
require 'bcrypt'

class Seeder
  
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
    db.execute('DROP TABLE IF EXISTS users')
  end

  def self.create_tables
    db.execute('CREATE TABLE todos (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT)')
    db.execute('CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, password TEXT)')

  end

  def self.populate_tables
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 1", "This task needs to be done")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 2", "This task needs to be done")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 3", "This task needs to be done")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 4", "This task needs to be done")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 5", "This task needs to be done")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Task: 6", "This task needs to be done")')
    db.execute('INSERT INTO todos (username, password) VALUES ("Admin", "adminPass")')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/todos.sqlite')
    @db.results_as_hash = true
    @db
  end
end


Seeder.seed!