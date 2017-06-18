require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'public/mastermind'

configure do
  enable :sessions
  set :session_secret, "meow"
end

get '/' do
  @session = session
  erb :index
end

get '/mastermind/choose' do
  erb :choose_game_type
end

post '/mastermind/play' do
  game_type = params["submit"]
  print game_type
  mastermind = Mastermind.new
  mastermind.choose_game_type(game_type)
  
  #mastermind.play
  erb :mastermind, :locals => {:mastermind => mastermind, :game_type => game_type}
end
