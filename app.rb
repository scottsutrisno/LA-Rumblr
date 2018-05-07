require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require "sinatra/content_for"
require "./models"
require "pry"

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
    @posts = Post.all
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
    email: params[:email],
   created_at: params[:created_at]
  )
  Profile.create(
    user_id: @user.id,
    avatar: "/images/default.jpg"
  )
  session[:user_id] = @user.id
  flash[:info] = "Welcome #{params[:name]}"
  redirect "/"
end




get "/sign-out" do
  session[:user_id] = nil
  redirect "/"
end


get "/deleted" do
  erb :deleted
end

put "/settings" do
  @user = User.find(session[:user_id])
  @user.profiles.update(
    first_name: params[:first_name],
    last_name: params[:last_name],
    birthday: params[:birthday],
    about_me: params[:about_me],
    avatar: params[:avatar]
  )
  redirect "/profile"
end

get "/settings" do
@user = User.find(session[:user_id])
erb :settings
end


get "/confirmation" do
@user = User.find(session[:user_id])
erb :confirmation
end

post "/confirmation" do

for post in Post.all
    if post.user_id == User.find(session[:user_id]).id
        Post.destroy(post.id)
    end
end

@user = User.find(session[:user_id])
@userdestroy = @user.destroy
@userdestroy

session[:user_id] = nil
redirect "/deleted"
end





get "/users" do
 @userlist = User.all.map { |user|
 "Username: #{user.username}  --
 Password: #{user.password}
" }.join("  <br>  ")
end



get "/profile" do
@user = User.find(session[:user_id])
erb :profile
end

post "/profile" do
@user = User.find(session[:user_id])
@post = Post.create(
    user_id: @user.id,
    title: params[:title],
    content: params[:content],
    image: params[:image]
)
redirect "/profile"
end


get "/delete/:id" do
    post = Post.find(params[:id])
    Post.destroy(post.id)
redirect "/"

end

get "/deletes/:id" do
    post = Post.find(params[:id])
    Post.destroy(post.id)
redirect "/profile"

end









get "/profile/:id" do
@user = User.find(params[:id])
@posts = User.find(params[:id]).posts
erb :user_post
end

post "/search" do
  @user = User.find_by(username: params[:search])
  redirect "/profile/#{@user.id}"
end












