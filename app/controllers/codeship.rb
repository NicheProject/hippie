# Codeship webhook handler
#   -- bridges codeship events into hipchat room
#
# Author::    Michael Heijmans  (mailto:parabuzzle@gmail.com)
# Copyright:: Copyright (c) 2015 Michael Heijmans
# License::   MIT

Hippie::App.controllers :codeship, conditions: {:protect => true} do

  post '/notify/:room/:auth_token' do
    request_payload = convert_json_body(request)
    build           = request_payload['build']
    build_url       = build['build_url']
    commit_url      = build['commit_url']
    project_id      = build['project_id']
    build_id        = build['build_id']
    status          = build['status']
    project_name    = build['project_full_name']
    commit_id       = build['commit_id']
    short_commit_id = build['short_commit_id']
    message         = build['message']
    committer       = build['committer']
    branch          = build['branch']
    token           = request_payload['token'] || Hippie::App.room_keys[room]
    room            = params['room']

    logger.info request_payload.to_s

    halt 500, 'missing room' unless room
    halt 500, 'missing room token' unless token

    color = 'purple'
    color = 'red'    if status.match(/error/)
    color = 'yellow' if status.match(/stopped/)
    color = 'green'  if status.match(/success/)

    notify = false
    notify = true if branch == 'master'

    text_opts = { color: color, token: token, notify: notify }
    html_opts = { color: color, token: token, format: 'html', notify: notify }

    msg = []
    if status == 'error'
      user = map_github_user(committer)
      msg << "(stare) #{user} you broke the build!"
      msg << "Project: #{project_name}"
      msg << "Branch: #{branch}"
      msg << "Commit: #{commit_url}"
      msg << "Info: #{build_url}"
    end

    post_to_room(room, msg.join("\n"), text_opts) unless msg.empty?
  end

end

def map_github_user(user)
  hipchat_user = Hippie::App.codeship_users[user]
  hipchat_user ? "@#{hipchat_user}" : "@#{user}"
end

