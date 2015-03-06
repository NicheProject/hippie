# A simple utility route for echoing back and logging everything coming in from a webhook
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :util do

  get '/ping' do
    "OK"
  end

  get '/echo' do
    echo
  end

  post '/echo' do
    echo
  end

  get '/test/:room' do
    token = params[:token] || Hippie::App.room_keys[room]
    post_to_room(params['room'], params['msg'], {token: token})
  end

end
