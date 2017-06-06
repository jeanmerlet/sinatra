require 'sinatra'

get '/hi' do
  'Hello world!'
end

get '/hello/:name' do
  "Hello #{params['name']}!"
end
