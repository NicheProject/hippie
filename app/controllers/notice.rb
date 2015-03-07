# /notice processor for Hipchat room
#   -- use /notice to notify everyone in a room with the passed in message
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :notice, conditions: {:protect => true} do

  post '/process/:auth_token' do
    request_payload = convert_json_body(request)
    message = request_payload['item']['message']['message'].gsub('/notice', '')
    respond(message, {color: 'red', notify: true})
  end


end
