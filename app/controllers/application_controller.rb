class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do

    erb :'/registrations/signup'
  end

  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    # We registered a new user! Now we just need to sign them in. 
    session[:user_id] = @user.id
    # Now that we've signed up and logged in our user, we want to take them to their homepage.
    redirect '/users/home'
  end

  get '/sessions/login' do

    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      # If user is found, login them in and redirect to their homepage
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    # If user is not found, take them to the login page.
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    # First, this route finds the current user based on the ID value stored in the session hash. Then, it sets an instance variable, @user, equal to that found user, allowing us to access the current user in the corresponding view page.
    erb :'/users/home'
  end
end
