require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

post '/cipher/' do
  message = params["message"]
  shift = params["shift"].to_i
  cipher = caesar_cipher(message, shift)
  erb :cipher, :locals => {:cipher => cipher}
end

def caesar_cipher(string, shift)
  return nil if string.empty? || string[/^[a-zA-Z\s]+$/] != string
  return nil unless (0..25) === shift

  string.length.times do |i|
    if string[i].ord != 32
      letter_ordinal = string[i].ord + shift
      if (97..122) === string[i].ord && letter_ordinal > 122
        letter_ordinal = (letter_ordinal % 122) + 96
      elsif (65..90) === string[i].ord && letter_ordinal > 90
        letter_ordinal = (letter_ordinal % 90) + 64
    end
    string[i] = letter_ordinal.chr
    end
  end
  string
end
