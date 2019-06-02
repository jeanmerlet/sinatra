require 'sinatra'
require 'sinatra/reloader' if development?
require './mastermind.rb'

game = Mastermind.new

get '/mastermind' do
  game.reset
  erb :index
end

get '/mastermind/' do
  game_type = params["game_type"]
  if game_type != 'codebreaker' && game_type != 'codemaster'
    redirect to('/mastermind')
  else
    game.choose_game_type(game_type)
    if game_type == 'codebreaker'
      game.create_code
      redirect to('/mastermind/play')
    else game_type == 'codemaster'
      redirect to('/mastermind/create-code')
    end
  end
end

get '/mastermind/play' do
  if game.codebreaker.is_a?(AI)
    @button_message = "Again!"
    until game.board.solved?
      game.guess
    end
  else
    @button_message = "Guess!"
  end
  @colors = game.full_name_guesses
  @feedback = game.board.feedback
  @win = game.board.solved?
  erb :game_board
end

get '/mastermind/create-code' do
  redirect to('/mastermind/play') if game.board.code != ""
  @button_message = "Encode!"
  @colors = game.full_name_guesses
  @feedback = game.board.feedback
  erb :game_board
end

get /\/mastermind\/([RGBOPW]{4})/ do
  guess = params['captures'].first
  if game.board.code == ""
    game.board.code = guess
  else
    game.guess(guess)
  end
  redirect to('/mastermind/play')
end
