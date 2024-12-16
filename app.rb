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
          redirect('todos/admin/home')
          erb(:"todos/admin/home")
        else
          redirect('/todos/index')
          erb(:"todos/index")
        end
    end

    configure do
        enable :sessions
        set :session_secret, SecureRandom.hex(64)
    end
    
    get '/todos/index' do
      erb(:"todos/index")
    end

    post '/todos/index' do
        request_username = params[:username]
        request_plain_password = params[:password]
    
        user = db.execute("SELECT * FROM user WHERE username = ?", request_username).first
    
        unless user
            p "/todos/index : Invalid username."
            status 401
            redirect '/todos/unauthorized'
        end
        
        db_id = user["id"].to_i
        db_password_hashed = user["password"].to_s
    
        bcrypt_db_password = BCrypt::Password.new(db_password_hashed)

        if bcrypt_db_password == request_plain_password
          p "/todos/admin/home : Logged in -> redirecting to admin"
          session[:user_id] = db_id
          redirect '/todos/admin/home'
        else
          p "/todos/index : Invalid password."
          status 401
          redirect '/todos/unauthorized'
        end
    
    end
    
    get '/todos/unauthorized' do
      erb(:"todos/unauthorized")
    end
    
    get '/todos/logout' do
      p "/logout : Logging out"
      session.clear
      redirect '/'
    end

    get '/todos/admin/home' do
      @todos = db.execute('SELECT * FROM todos')
      erb(:"todos/admin/home")
    end

    get '/todos/admin/:id/show' do |id|
      @todo = db.execute('SELECT * FROM todos where id=?', id).first

      erb(:"todos/admin/show")
    end

    get '/todos/admin/:id/edit' do |id|
      @id = params[:id]
      @todo = db.execute('SELECT * FROM todos where id=?', id.to_i).first
      erb(:"todos/admin/edit")
    end

    get '/todos/admin/new' do
      erb(:"todos/admin/new")
    end
    
    post '/todos/admin/home' do
      name = params[:tsk_name] 
      desc = params[:tsk_desc] 
      
      db.execute("INSERT INTO todos (name, description) VALUES(?, ?)", [name, desc])
      redirect('todos/admin/home')
    end 

    post '/todos/admin/:id/delete' do | id |
      db.execute('DELETE FROM todos WHERE id=?', params['id'])
      redirect('/todos/admin/home')
    end
    post "/todos/admin/:id/update" do | id |
      name = params[:tsk_name]
      desc = params[:tsk_desc] 

      db.execute('UPDATE todos SET name=?, description=? WHERE id=?', [name, desc, id])
      redirect('todos/admin/home')
    end

end
