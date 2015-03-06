# Capistrano webhook handler
#   -- bridges codeship events into hipchat room
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :capistrano do

  post '/notify/:room' do
    request_payload = convert_json_body(request)
    message         = request_payload['message']
    color           = request_payload['color']
    notify          = request_payload['notice']
    room_name       = request_payload['room']
    room            = params['room']
    token           = params['token'] || Hippie::App.room_keys[room]

    logger.info request_payload.to_s

    halt 500, 'missing room' unless room
    halt 500, 'missing room token' unless token

    text_opts = { color: color, token: token, notify: notify }
    html_opts = { color: color, token: token, format: 'html', notify: notify }

    post_to_room(room, message, text_opts) unless message.empty?
  end

end

