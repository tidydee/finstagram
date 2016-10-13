#helper methods
helpers do
  def current_user
    User.find_by({id: session[:user_id]})
  end
end

get '/' do
  @posts = Post.order(created_at: :desc)
  erb(:index)
end

get '/login' do
  erb(:login)
end
  
post '/login' do
  puts "============================="
  puts params
  #escape_html params
  
  login_username = params[:username]
  login_password = params[:password]
  
  user = User.find_by({ username: login_username})
  
  if user && user.password == login_password
    session[:user_id] = user.id
    "Success! User with id #{session[:user_id]} is logged in!"
    redirect to('/')
  else
    @error_message = "Incorrect username and password."
    erb(:login)
  end

end

get '/logout' do
  puts session[:user_id] = nil
  #puts session.clear
  puts "Logout successful!"
  "Logout successful!"
  redirect to('/')
end

get '/signup' do    #if user navigates to the path "/signup"
  @user = User.new  #setup empty @user objet
  erb(:signup)      #render "app/views/signup.erb"
end

post '/signup' do
  # grab user input values from params
  email      = params[:email]
  avatar_url = params[:avatar_url]
  username   = params[:username]
  password   = params[:password]

  # instantiate and save a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
  
  # if user validations pass and user is saved
  if @user.save

  "User #{username} saved!"
  
  redirect to('/login')

  else
    erb(:signup)
  end
end