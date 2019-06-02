require 'sinatra'

get '/' do
  erb :index
end

get '/choose_game' do
  game = params["game"]
  if game == 'mastermind'
    require './webstermind/webstermind'
    redirect to('/mastermind')
  elsif game == 'web_guesser'
    require './web_guesser/web_guesser/'
    redirect to('/web_guesser')
  elsif game == 'web_cipher'
    require './web_cipher/web_cipher'
    redirect to('/web_cipher')
  end
end
