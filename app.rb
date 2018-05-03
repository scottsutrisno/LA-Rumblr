require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require "sinatra/content_for"
require "./models"

set :database, "sqlite3:app.db"

configure :development do
  set :database, "sqlite3:app.db"
end

configure :production do
  # this environment variable is auto generated/set by heroku
  #   check Settings > Reveal Config Vars on your heroku app admin panel
  set :database, ENV["DATABASE_URL"]
end

enable :sessions

get "/" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :signed_home
  else
    erb :index
  end
end


# responds to sign in form
post "/" do
  @user = User.find_by(username: params[:username])
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:info] = "Welcome #{params[:username]}"
    redirect "/"
  else
    flash[:warning] = "Your username or password is incorrect"
    redirect "/"
  end
end


get "/sign-up" do
  erb :sign_up
end





post "/sign-up" do
  @user = User.create(
    username: params[:username],
    password: params[:password],
    birthday: params[:birthday],
    email: params[:email],
   created_at: params[:created_at]
  )
  session[:user_id] = @user.id
  flash[:info] = "Welcome #{params[:name]}"
  redirect "/"
end




get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil
  erb :sign_out
end

get "/settings" do
  erb :settings
end

get "/users" do
 @userlist = User.all.map { |user|
 "Username: #{user.username}  --
 Password: #{user.password}  --
 Birthday: #{user.birthday}  --
 Email: #{user.email}  --
 Created At #{user.created_at}
" }.join("  <br>  ")
end

get "/profile" do
@user = User.find(session[:user_id])
erb :profile
end

get "/profile/:id" do
@user_id = User.find(params[:id]) # finds id
#  params[:id]
end