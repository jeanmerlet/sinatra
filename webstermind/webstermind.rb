require 'sinatra'
require 'sysrandom/securerandom' if development?
require 'sinatra/reloader' if development?

enable :sessions
set :session_secret, ENV['SESSION_KEY']
set :session_secret, SecureRandom.hex(64) if development?
set :sessions, :expire_after => 2592000

class MastermindSessionManager
  def initialize
    @colors = ["B", "G", "O", "P", "R", "W"]
    @code_set = @colors.repeated_permutation(4).to_a.map { |x| x.join }
    @parsed_feedback = []
  end

  def create_code
    code = ""
    4.times { code << @colors[rand(6)] }
    code
  end

  def update_guesses(guess, guesses, turn)
    guesses[turn] = guess
  end

  def update_feedback(code, guess, feedback, turn)
    _code = code.dup
    _guess = guess.dup
    result = []

    4.times do |i|
      if _guess[i] == _code[i]
        result << "+"
        _code[i] = "0"
        _guess[i] = "1"
      end
    end

    4.times do |i|
      if _code.include?(_guess[i])
        result << "-" 
        _code[_code.index(_guess[i])] = "0"
        _guess[i] = "1"
      end
    end

    (4 - result.length).times { result << " " }
    feedback[turn] = result
  end

  def reset
    @code_set = @colors.repeated_permutation(4).to_a.map { |x| x.join }
    @parsed_feedback = []
    guesses = Array.new(12) { "" }
    feedback = Array.new(12) { "    " }
    turn = 0
    [guesses, feedback, turn]
  end

  def solved?(guesses, guess)
    return false if guesses == nil or guess == nil
    return true if guesses.include?(guess)
    false
  end

  def guess(guesses, feedback, turn)
    return "BBGG" if turn == 0
    @parsed_feedback << count_feedback(feedback, turn)
    eliminate_bad_guesses(guesses, turn)
    @code_set[0]
  end

  def count_feedback(feedback, turn)
    result = [0, 0]
    4.times do |i|
      result[0] += 1 if feedback[turn-1][i] == "+"
      result[1] += 1 if feedback[turn-1][i] == "-"
    end
    result << result[0] + result[1]
  end

  def eliminate_bad_guesses(guesses, turn)
    last_guess = guesses[turn-1]
    @code_set -= [last_guess]

    @code_set.reject! do |code|
      matches = 0
      perfect_matches = 0
      temp_code = code.dup
      result = false

      4.times do |i|
        if temp_code.include?(last_guess[i])
          matches += 1
          temp_code.sub!(/#{last_guess[i]}/, "0")
        end
        perfect_matches += 1 if code[i] == last_guess[i]
      end

      result = true if matches != @parsed_feedback.last[2] ||
                       perfect_matches != @parsed_feedback.last[0]
    end
  end
end

game = MastermindSessionManager.new

get '' do
  redirect to('/mastermind/new')
end

get '/' do
  redirect to('/mastermind/new')
end

get '/mastermind' do
  redirect to('/mastermind/new')
end

get '/mastermind/' do
  redirect to('/mastermind/new')
end

get '/mastermind/new' do
  if game.solved?(session[:guesses], session[:code]) || session[:code].nil?
    session.clear
    session[:guesses], session[:feedback], session[:turn] = *game.reset
  end
  erb :choice
end

get '/mastermind/choose-game-type' do
  game_type = params['game_type']
  if (game_type == 'codebreaker' || game_type == 'codemaster')
    session[:game_type] = game_type
    if game_type == 'codebreaker'
      session[:code] = game.create_code if session[:code].nil?
      redirect to('/mastermind/play')
    else
      redirect to('/mastermind/create-code')
    end
  end
end

get '/mastermind/play' do
  redirect to('/mastermind/new') if session[:code].nil?
  if session['game_type'] == 'codemaster'
    while !session[:guesses].include?(session[:code])
      guess = game.guess(session[:guesses], session[:feedback], session[:turn])
      game.update_guesses(guess, session[:guesses], session[:turn])
      game.update_feedback(session[:code], guess, session[:feedback], session[:turn])
      session[:turn] += 1
    end
  end
  @guesses = session[:guesses]
  @feedback = session[:feedback]
  @new_game = session[:guesses].include?(session[:code])
  @new_game = true if session[:turn] >= 12
  erb :board
end

get '/mastermind/create-code' do
  redirect to('/mastermind/play') if !session[:code].nil?
  @encode = "Encode!"
  @guesses = session[:guesses]
  @feedback = session[:feedback]
  erb :board
end

get /\/mastermind\/([BGOPRW]{4})/ do
  guess = params['captures'].first
  if session[:code].nil?
    session[:code] = guess
  else
    game.update_guesses(guess, session[:guesses], session[:turn])
    game.update_feedback(session[:code], guess, session[:feedback], session[:turn])
    session[:turn] += 1
  end
  redirect to('/mastermind/play')
end
