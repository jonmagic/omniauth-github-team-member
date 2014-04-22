# OmniAuth GitHub Team Auth

This is an OmniAuth strategy for authenticating to GitHub and ensuring the user belongs to a specific team. This strategy is useful for building web apps that should only be administered by specific teams. I adapted this from an internal gem at GitHub.

To use it, you'll need to sign up for an OAuth2 Application ID and Secret on the [GitHub Applications Page](https://github.com/settings/applications).

## Installing

Add the gem to your Gemfile and bundle.

```
gem "omniauth-github-team-member"
```

I like to store the GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET in my environment, but you don't have to if you have a preferred place to put keys and secrets. For local development I recommend the [dotenv](https://github.com/bkeepers/dotenv) gem for setting environment variables.

## Basic Usage

Usage in Rails:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :githubteammember,
    ENV['GITHUB_CLIENT_ID'],
    ENV['GITHUB_CLIENT_SECRET'],
    :scope => 'user',
    :teams => {
      "mentors_team_member?" => 426344
    }
end
```

During the callback phase, you can check to see if the authed user is on the mentors team or not
by checking the returned credentials object `request.env['omniauth.auth'].credentials.mentors_team_member?`.

An example of how to integrate this strategy with OmniAuth is below. Do note that these
examples are just guidelines, you will most likely need to change each example to match your application's needs.

```ruby
class SessionsController
  def create
    @user = User.find_for_github_team_oauth(request.env['omniauth.auth'])

    if @user && @user.persisted?
      redirect_to root_path
    else
      redirect_to no_access_path
    end
  end
end
```

```ruby
class User < ActiveRecord::Base
  def self.find_for_github_team_oauth(access_token, signed_in_resource=nil)
    # Prevents past team members from logging into existing accounts they
    # created when they were previously a team member. Also ensures
    # new accounts can't be created unless they are a team member.
    return false unless access_token.credentials.mentors_team_member?

    info = access_token.info
    github_id = access_token.uid
    user = find_or_initialize_by_github_id(github_id)

    if user.new_record?
      user.name = info.name
      user.email = info.email
      user.github_identifier = info.nickname
      user.save
    end

    user
  end
end
```

Usage in Sinatra:

```ruby
use OmniAuth::Builder do
  provider :githubteammember,
    ENV['GITHUB_CLIENT_ID'],
    ENV['GITHUB_CLIENT_SECRET'],
    :scope => 'user',
    :teams => {
      "mentors_team_member?" => 426344
    }
end
```

### Scopes

You must require the user scope to be able to access the team data associated with
the authenticated user.

More info on [Scopes](http://developer.github.com/v3/oauth/#scopes).

## Contributing

1. [Fork it](https://help.github.com/articles/fork-a-repo)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://help.github.com/articles/using-pull-requests)

## Contributors

* [Garrett Bjerkhoel](https://github.com/dewski)
* [Jonathan Hoyt](https://github.com/jonmagic)
* [Arthur Chiu](https://github.com/achiu)
