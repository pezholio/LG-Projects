require 'open-uri'
Dotenv.load

class Authorities

  def self.all
    url = "https://raw.githubusercontent.com/github/government.github.com/gh-pages/_data/governments.yml"
    yaml = Rails.cache.fetch(url) do
      YAML.load(open(url).read)['United Kingdom']
    end
    yaml.map! do |u|
      Authorities.new(u)
    end
    yaml.sort_by! {|y| y.name}
  end

  def initialize(username)
    @user = Rails.cache.fetch(username) do
      github.users.get(user: username).body
    end
  end

  def username
    @user['login']
  end

  def name
    @user['name'].presence || @user['login']
  end

  def repos
    Rails.cache.fetch("#{name}-repos") do
      github.repos.list(user: username).body
    end
  end

  def avatar
    @user['avatar_url'] + "s=64"
  end

  private

    def github
      @@github ||= nil
      if @@github.nil?
        @@github = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
      end
      @@github
    end

end
