require 'sinatra'
require 'sinatra/reloader' if development?
require './mastermind.rb'

game = Mastermind.new

get '/mastermind' do
  erb :index
end

get '/mastermind/' do
  game_type = params["game_type"]
  if game_type == 'codebreaker'
    game.choose_game_type(game_type)
    game.create_code
    game.create_board(game.code)
    redirect to('/mastermind/play')
  elsif game_type == 'codemaster'
    game.choose_game_type(game_type)
    game.create_board("PPPW")
    #redirect to('/mastermind/create-code')
    redirect to('/mastermind/play')
  else
    redirect to('/mastermind')
  end
end

get '/mastermind/play' do
  if game.codebreaker.is_a?(AI)
    until game.board.solved?
      game.guess
    end
  end
  @colors = game.full_name_guesses
  @feedback = game.board.feedback
  erb :game_board
end

get '/mastermind/create-code' do
  erb :game_board
end

get /\/mastermind\/code=([RGBOPW]{4})/ do
  guess = params['captures'].first
  if game.board.nil?
    game.create_code(guess)
    game.create_board(game.code)
  end
end

get /\/mastermind\/([RGBOPW]{4})/ do
  guess = params['captures'].first
  game.guess(guess)
  redirect to('/mastermind/play')
end
