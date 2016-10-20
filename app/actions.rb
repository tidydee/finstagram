#helper methods
helpers do
  def current_user
    User.find_by({id: session[:user_id]})
  end
  
  def logged_in?
    current_user ? current_user : nil
    #if current_user != nil
    # current_user
    #end
  end
end

#before filters
before '/posts/new' do
  redirect '/login' unless logged_in?
end

#homepage route
get '/' do
  @posts = Post.order(created_at: :desc)
  erb(:index)
end


#users routes
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


#posts routes
get '/posts/new' do
  @post = Post.new()
  erb(:'posts/new')
end

post '/posts' do
  photo_url = params[:photo_url]
  
  @post = Post.new({photo_url: photo_url, user_id: current_user.id})
  
  if @post.save
    redirect to('/')
  else
    erb(:"posts/new")
  end
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb(:"posts/show")
end

#comments route
post '/comments' do
  params.to_s
  text = params[:text]
  post_id = params[:post_id]
  
  comment = Comment.new(text: text, post_id: post_id, user_id: current_user.id)
  
  comment.save
  
  redirect(back)
end

#likes route
post '/likes' do
  post_id = params[:post_id]
  
  like = Like.new(post_id: post_id, user_id: current_user.id)
  
  like.save
  
  redirect(back)
end

delete '/likes/:id' do
  like = Like.find_by(params[:id])
  like.destroy
  redirect(back)
end