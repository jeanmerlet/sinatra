set :root, File.dirname(__./webstermind/__)

require 'sinatra'
require 'sinatra/reloader' if development?
require './mastermind.rb'


game = Mastermind.new

get '/' do
  redirect to('/mastermind')
end

get '/mastermind' do
  game.reset
  erb :game_choice
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
    game.guess until game.board.solved?
  end
  @colors = game.full_name_guesses
  @feedback = game.board.feedback
  @win = game.board.solved?
  @button_message = (@win ? "Again!" : "Guess!")
  erb :game_board
end

get '/mastermind/create-code' do
  redirect to('/mastermind/play') if game.board.code != ""
  @button_message = "Encode!"
  @colors = game.full_name_guesses
  @feedback = game.board.feedback
  @win = false
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
