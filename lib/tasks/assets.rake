# The premise behind this was borrowed from https://gist.github.com/1239732
namespace :assets do
  # Prepend the assets:prepare task to assets:precompile through
  # assets:environment
  task :environment => :prepare

  task :prepare do
    # Flag for custom initializers to know we're precompiling assets
    ENV["RAILS_ASSETS_PRECOMPILE"] = "true"

    # Prevent mongoid from loading
    def Mongoid.load!(*args)
      true
    end
  end
end
