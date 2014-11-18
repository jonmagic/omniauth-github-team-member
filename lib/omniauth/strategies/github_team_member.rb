require 'omniauth-github'

module OmniAuth
  module Strategies
    class GitHubTeamMember < OmniAuth::Strategies::GitHub
      credentials do
        options['teams'].inject({}) do |base, key_value_pair|
          method_name, team_id = key_value_pair
          base[booleanize_method_name(method_name)] = team_member?(team_id)
          base
        end
      end

      def team_member?(team_id)
        response = access_token.get("/teams/#{team_id}/memberships/#{raw_info['login']}")
        response.status == 200 && response.parsed["state"] == "active"
      rescue ::OAuth2::Error
        false
      end

      def booleanize_method_name(method_name)
        return method_name if method_name =~ /\?$/
        return "#{method_name}?"
      end
    end
  end
end

OmniAuth.config.add_camelization "githubteammember", "GitHubTeamMember"
