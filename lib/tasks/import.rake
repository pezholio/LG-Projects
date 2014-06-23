require 'open-uri'

namespace :import do
  desc "Imports all authorities"
  task :authorities  => :environment do
    users = Import.load_authorities
    users.each do |u|
      Import.import_authority(u)
    end
  end
end

class Import

  def self.load_authorities
    url = "https://raw.githubusercontent.com/github/government.github.com/gh-pages/_data/governments.yml"
    YAML.load(open(url).read)['United Kingdom']
  end

  def self.import_authority(user)
    user = github.users.get(user: user).body
    authority = Authority.find_or_initialize_by(username: user['login'])
    authority.write_attributes(
        name: user['name'].presence || user['login'],
        avatar: user['avatar_url'] + "s=64",
        repos: get_repos(authority)
    )
    authority.save
  end

  def self.get_repos(authority)
    github.repos.list(user: authority.username).body.map! do |r|
      repo = Repo.find_or_initialize_by(name: r['name'])
      civic = get_civic(authority.username, r['name'])
      repo.write_attributes(
        description: r['description'],
        url: r['html_url'],
        civic_present?: (civic.count != 0),
        thumbnail: civic['thumbnailUrl'],
        owner: civic['owner'],
        deployments: civic['deployments'],
        status: civic['status'],
        service_categories: civic['serviceCategories'],
        technologies: civic['technologies'],
        authority: authority
      )
      repo.save
      repo
    end
  end

  def self.get_civic(username, repo_name)
    begin
      json = open("https://raw.githubusercontent.com/#{username}/#{repo_name}/master/civic.json").read
      civic = JSON.parse(json)
    rescue OpenURI::HTTPError
      civic = {}
    end
    civic
  end

  def self.github
    @@github ||= nil
    if @@github.nil?
      @@github = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
    end
    @@github
  end

end
