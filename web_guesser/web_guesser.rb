number = 1 + rand(100)

get '/web_guesser' do
  guess = params["guess"].to_i
  message = check_guess(guess, number)
  erb :web_guesser, :locals => {:number => number, :message => message}
end

def check_guess(guess, number)
  if guess > number + 5
    "Way too high!"
  elsif guess > number
    "Too high!"
  elsif guess < number - 5
    "Way too low!"
  elsif guess < number
    "Too low!"
  else
    "You got it right!"
  end
end
