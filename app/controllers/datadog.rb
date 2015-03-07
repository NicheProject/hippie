# DataDog webhook handler
#   -- bridges datadog events into hipchat room
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :datadog, conditions: {:protect => true} do

  post '/notify/:room/:auth_token' do
    request_payload = convert_json_body(request)
    title           = request_payload["title"]
    event_type      = request_payload["event_type"]
    body            = request_payload["body"]
    link            = request_payload["link"]
    snapshot        = request_payload["snapshot"]
    room            = params['room']
    token           = request_payload['token'] || Hippie::App.room_keys[room]

    halt 500, 'missing room' unless room
    halt 500, 'missing room token' unless token

    color = 'purple'
    color = 'yellow' if title.match(/^\[Triggered\]/)
    color = 'green'  if title.match(/^\[Recovered\]/)

    text_opts = { color: color, token: token }
    html_opts = { color: color, token: token, format: 'html' }

    # post to room
    post_to_room(room, title, text_opts) unless title.length < 4
    post_to_room(room, markdown.render(body.gsub('%%%', '')), html_opts)
    post_to_room(room, "<img src='#{snapshot}'/>", html_opts) unless snapshot.empty? || title.match(/^\[Triggered\]/)
    post_to_room(room, link, text_opts)
  end

end
