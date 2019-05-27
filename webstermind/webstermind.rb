require 'sinatra'
require 'sinatra/reloader' if development?
require './mastermind.rb'

game = Mastermind.new

get '/mastermind' do
  erb :index
end

get '/mastermind/' do
  game_type = params["game_type"]
  game.choose_game_type(game_type)
  if game_type == 'codebreaker'
    game.create_code
    game.create_board(game.code)
    redirect to ('/mastermind/play')
  else
    redirect to ('/mastermind/create-code')
  end
end

get '/mastermind/play' do
  if game.codebreaker.is_a?(AI)
    game.guess("ai")
    erb :game_board, :locals => {:guesses => game.board.guesses, :feedback => game.board.feedback}
    sleep 0.5
    redirect to ('/mastermind/play')
  else
    erb :game_board
  end
end

get '/mastermind/create-code' do
  erb :board_header
end

get /\/mastermind\/([RGBOPW]{4})/ do
  guess = params['captures'].first
  game.guess(guess)
  redirect to ('/mastermind/play')
end
