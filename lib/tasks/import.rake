require 'open-uri'

namespace :import do
  desc "Imports all authorities"
  task :authorities  => :environment do
    Import.perform
  end
end

class Import

  def self.perform
    users = Import.load_authorities
    users.each do |u|
      Import.import_authority(u)
    end
    Delayed::Job.enqueue Import, run_at: 1.day.from_now
  end

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
        created: DateTime.parse(r['created_at']),
        language: r['language'],
        commits: get_commit_count(r),
        stars: r['stargazers_count'],
        forks: r['forks_count'],
        issues: r['open_issues_count'],
        contributors: get_contributors(r),
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

  def self.get_commit_count(repo)
    begin
      github.repos.commits.all(repo['owner']['login'], repo['name']).count
    rescue Github::Error::ServiceError
      nil
    end
  end

  def self.get_contributors(repo)
    begin
      github.repos.contributors(repo['owner']['login'], repo['name']).map do |c|
        {
          name: c['login'],
          url: c['html_url'],
          avatar_url: c['avatar_url']
        }
      end
    rescue Github::Error::ServiceError
      []
    end
  end

  def self.github
    @@github ||= nil
    if @@github.nil?
      @@github = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
    end
    @@github
  end

end
