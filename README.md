#Hippie

Hippie makes it easy to build webhooks based hipchat integrations

![Hippie](http://i.imgur.com/hf7fkEm.jpg)


## WHY?

HipChat has moved away from normal "Bot" integrations in favor of Webhook based integrations with their new V2 API. This means that there was a need for a way to whip-up quick http endpoints for handling this new way of creating hipchat room integrations.

With Hippie, you can define an endpoint for publishing into a room from an outside source [like a Capistrano script](https://github.com/parabuzzle/hippie/blob/master/app/controllers/capistrano.rb). Or you can setup a `/` based command like [/notice](https://github.com/parabuzzle/hippie/blob/master/app/controllers/notice.rb).

The point here was to make an ease framework for hosting these webhook endpoints that provides helpers for working with the HipChat way of doing things.

More on HipChat Webhooks: https://www.hipchat.com/docs/apiv2/webhooks

More on Addons: https://www.hipchat.com/docs/apiv2/addons


## tl;dr

  * Put your routes in `app/controllers`
  * Put your config in `config/apps`
  * Deploy to Heroku
  * Set the `HIPPIE_SESSION_SECRET` && `HIPPIE_AUTH_TOKEN` environment variables before using it

*note: you can run it locally via `bin/hippie`*


## So How Does it Work?

Hippie uses Padrino and is designed to work on Heroku. All configuration is setup as an environment variable and all endpoints are simple sinatra routes in `app/controllers`. Hippie also provides you with some helpers for working with HipChat:

  * `respond(msg, opts={})` - for working with `/commands`
  * ` post_to_room(room, msg, opts={})` - for posting to a room directly (like external services using hippie as a webhook)
  * `get_msg(json)` - returns the message sent when using a `/command`
  * `convert_json_body(request)` - returns a hash of the json body that was sent to Hippie
  * `markdown` - returns a Redcarpet markdown object setup for rendering HipChat compatible HTML.


#### But, why use Hippie for service integrations when the service (such as Codeship) already has a HipChat plugin?

I'm glad you asked. Most plugin integrations for HipChat on services like Codeship or DataDog, rely on the V1 API and require a "Notification Token" from the HipChat administrator. This Notification token gives access to post in all rooms and most administrators are not a fan. Plus the V1 api is no longer a supported api by HipChat (and will probably go away someday). The V2 api is a per room token and a room owner can generate a V2 token for their room or install a "Custom Integration" that will also create such a token. Hippie gives you an easy way to leverage the Service's Webhook integration to talk on this new V2 api. (Plus it gives you a single point of entry to your room that can be killed anytime by you.)

## How do I deploy on Heroku

Another great question!

You just need to:

  1 fork this repository
  1 create an app on heroku (following the instructions to link your hippie repo to heroku)
  1 ...and deploy (`git push heroku master`)

There are a number of environment variables you will want to set though (a full list can be found in `config/apps.rb`)

These are the settings you should absolutely set before you start using Hippie:

  * `HIPPIE_SESSION_SECRET` - Set this to something big and unique
  * `HIPPIE_AUTH_TOKEN` - Set this to something big and unique. Hippie uses this for authenticating you calls (more later)
  * `ROOM_KEYS` - This is a comma-delimited list of room_id:token that hippie should know about (more later)

## HIPPIE_AUTH_TOKEN

All end points can be protected by this shared secret. Any controller that is defined with `conditions: {:protect => true}` will require this `auth_token` be present in the params of the request.

example: `http://myhippie.herokuapp.com/datadog/notify/123456/?auth_token=myauthtoken`

Without this token, the request will be denied.

#### But why not just use the room token?

Because we don't want to pass the room token over the wire. Its much easier to change a single auth token then all the room tokens if something gets compromised. As you'll see in the next section, you can use the room token *and* the auth_token to be super paranoid


## ROOM_KEYS

The room keys variable is a special variable that acts like a keychain for your HipChat rooms. Its a comma-delimited list of room_id:room_token.

example: `ROOM_KEYS=123456:adf807adgh09875da,67890:35hlkjhfao870986ga`

The example maps out to a hash like this:

```ruby
{
  '123456' => 'adf807adgh09875da',
  '67890'  => '35hlkjhfao870986ga'
}
```

And you can access that hash via `Hippie::App.room_keys`

#### But what if I don't want to save the keys in Hippie?

That's fine. You don't need to set this variable. The webhook endpoints should support a way of passing it as a `token` param.

example `http://myhippie.herokuapp.com/datadog/notify/123456/?auth_token=myauthtoken&token=adf807adgh09875da`

(notice the auth_token is still there)

The aim here was to make it as flexible as possible for you, the user.


## PLEASE HELP!

Hippie isn't perfect.. its a weekend project to solve a specific problem of mine. Hippie can be so much more and you can help get it there! If it doesn't do what you want, by all means, fork it and send a Pull Request back with your awesome changes!

I welcome any and all help!

  1 fork the repository
  1 create a feature branch
  1 add your awesome code
  1 send a pull request
  1 have a beer

## License

The MIT License (MIT)

Copyright (c) 2015 Michael Heijmans

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
