##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount('blog').to('/blog')
#   Padrino.mount('blog', :app_class => 'BlogApp').to('/blog')
#   Padrino.mount('blog', :app_file =>  'path/to/blog/app.rb').to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount('Admin').host('admin.example.org')
#   Padrino.mount('WebSite').host(/.*\.?example.org/)
#   Padrino.mount('Foo').to('/foo').host('bar.example.org')
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount('AppName', :app_file => 'path/to/file', :app_class => 'BlogApp').to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#

# Sets up a hash from env string
# string is format is key:value,key:value
def hash_from_env(env)
  return {} unless env
  env.split(',').each_with_object({}) do |item, hash|
    map = item.split(':')
    hash.store(map[0], map[1])
  end
end

Padrino.configure_apps do
  set :protection, :except => :path_traversal
  set :protect_from_csrf, false
  set :session_secret, ENV['HIPPIE_SESSION_SECRET'] || 'changethis'
  set :auth_token, ENV['HIPPIE_AUTH_TOKEN'] || 'changethistoo'
  set :hipchat_api, ENV['HIPCHAT_API'] || 'api.hipchat.com'

  # Room keys are optional, you should be able to pass the key via the url
  # This parses the environment variable $ROOM_KEYS and expects a comma-delimited list of room:token
  # example: ROOM_KEYS=room1:token1,room2:token2
  set :room_keys, hash_from_env(ENV['ROOM_KEYS'])

  # codeship users is a map of codeship to hipchat username
  # example: git_user:hipchat_user,git_user2:hipchat_user2
  set :codeship_users, hash_from_env(ENV['CODESHIP_USERS'])

end

# Mounts the core application for this project
Padrino.mount('Hippie::App', :app_file => Padrino.root('app/app.rb')).to('/')
