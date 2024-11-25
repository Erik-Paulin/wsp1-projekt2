require 'bcrypt'

class App < Sinatra::Base
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/todos.sqlite")
        @db.results_as_hash = true

        return @db
    end

    get '/' do
        if session[:user_id]
          redirect('todos/admin/index')
          erb(:"todos/admin/index")
        else
          redirect('/todos/index')
          erb(:"todos/index")
        end
    end

    get '/todos/index' do
      @todos = db.execute('SELECT * FROM todos')
      erb(:"todos/index")
    end

    configure do
        enable :sessions
        set :session_secret, SecureRandom.hex(64)
    end
    post '/login' do
        request_username = params[:username]
        request_plain_password = params[:password]
    
        user = db.execute("SELECT * FROM users WHERE username = ?", request_username).first
    
        unless user
            p "/login : Invalid username."
            status 401
            redirect '/unauthorized'
        end
        
        db_id = user["id"].to_i
        db_password_hashed = user["password"].to_s
    
        bcrypt_db_password = BCrypt::Password.new(db_password_hashed)

        if bcrypt_db_password == request_plain_password
          p "/login : Logged in -> redirecting to admin"
          session[:user_id] = db_id
          redirect '/admin'
        else
          p "/login : Invalid password."
          status 401
          redirect '/unauthorized'
        end
    
    end

    get '/' do
        @todos = db.execute('SELECT * FROM todos')
        erb(:"index")
    end

    

end
