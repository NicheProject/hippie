# Backup Gem webhook handler
#   -- bridges Backup events into hipchat room
#  http://meskyanichi.github.io/backup/v4/notifier-httppost/
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :backup, conditions: {:protect => true} do

  post '/notify/:room/:auth_token' do
    message         = params['message']
    status          = params['status']
    room            = params['room']
    token           = params['token'] || Hippie::App.room_keys[room]

    halt 500, 'missing room' unless room
    halt 500, 'missing room token' unless token

    color = case status
    when 'success' then :green
    when 'warning' then :yellow
    when 'failure' then :red
    else 'gray'
    end

    notify = case status
    when 'failure' then true
    else false

    text_opts = { color: color, token: token, notify: notify }

    post_to_room(room, message, text_opts) unless message.empty?
  end

end

