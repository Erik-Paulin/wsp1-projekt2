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
    db.execute('INSERT INTO todos (name, description) VALUES ("Äpple ", "En rund frukt som finns i många olika färger.")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Päron ", "En nästan rund, men lite avläng, frukt. Oftast mjukt fruktkött.")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Banan ", "En avlång gul frukt.")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Appelsin ", "En orange rund frukt.")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Mandarin ", "En orange rund frukt.")')
    db.execute('INSERT INTO todos (name, description) VALUES ("Tsatsuma ", "En orange rund frukt.")')
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