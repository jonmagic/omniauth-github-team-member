require 'omniauth-github'

module OmniAuth
  module Strategies
    class GitHubTeamMember < OmniAuth::Strategies::GitHub
      credentials do
        { 'team_member?' => github_team_member?(team_id) }
      end

      def github_team_member?(id)
        team_members = access_token.get("/teams/#{id}/members").parsed
        !!team_members.detect { |member| member['login'] == raw_info['login'] }
      end

      def team_id
        ENV["GITHUB_TEAM_ID"]
      end
    end
  end
end

OmniAuth.config.add_camelization 'github_team_member', 'GitHubTeamMember'
