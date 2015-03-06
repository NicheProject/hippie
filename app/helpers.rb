# Helper methods defined here can be accessed in any controller or view in the application

module Hippie
  class App
    module Helper

      def respond(msg, opts={})
        color  = opts[:color]  || 'yellow'
        notify = opts[:notify] || false
        format = opts[:format] || 'text'
        {
          "color"          => color,
          "message"        => msg,
          "notify"         => notify,
          "message_format" => format,
        }.to_json
      end

      def post_to_room(room, msg, opts={})
        color  = opts[:color]  || 'yellow'
        notify = opts[:notify] || false
        format = opts[:format] || 'text'
        token  = opts[:token]  || Hippie::App.room_keys[room]
        json = {
          "color"          => color,
          "message"        => msg,
          "notify"         => notify,
          "message_format" => format,
        }.to_json

        HTTParty.post(
          "https://#{Hippie::App.hipchat_api}/v2/room/#{room}/notification?auth_token=#{token}",
          body: json,
          headers: { 'Content-Type' => 'application/json' }
          ).body
      end

      def get_msg(json)
        json['item']['message']['message']
      end

      def convert_json_body(request)
        request.body.rewind
        JSON.parse request.body.read
      end

      def markdown
        Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(prettify: true, hard_wrap: true), autolink: true, tables: true)
      end

    end

    helpers Helper
  end
end
