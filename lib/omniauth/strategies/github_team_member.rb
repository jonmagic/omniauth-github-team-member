require 'omniauth-github'

module OmniAuth
  module Strategies
    class GitHubTeamMember < OmniAuth::Strategies::GitHub
      credentials do
        options['teams'].inject({}) do |base, key_value_pair|
          name, team_id = key_value_pair
          base[team_method_name(name)] = team_member?(team_id)
          base
        end
      end

      def team_member?(team_id)
        response = access_token.get("/teams/#{team_id}/members/#{raw_info['login']}")
        response.status == 204
      rescue ::OAuth2::Error
        false
      end

      def team_method_name(name)
        return name if name =~ /\?$/
        return "#{name}?" if name =~ /_team$/
        return "#{name}_team?"
      end
    end
  end
end

OmniAuth.config.add_camelization "githubteammember", "GitHubTeamMember"
