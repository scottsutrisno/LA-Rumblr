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


put "/settings" do
  @user = User.find(session[:user_id])
  @user.profiles.update(
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
redirect "/"
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










get "/deleteprofile/:avatar" do
    profile = Profile.find_by(params[:avatar])
    Profile.destroy(profile.avatar)
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














