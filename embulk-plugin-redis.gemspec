
Gem::Specification.new do |gem|
  gem.name          = "embulk-plugin-redis-url"
  gem.version       = "0.4.1"

  gem.summary       = %q{Embulk plugin for Redis (with URL connection string support)}
  gem.description   = gem.summary
  gem.authors       = ["Mitsunori Komatsu", "Tom Maiaroto"]
  gem.email         = ["komamitsu@gmail.com", "tom@funnelenvy.com"]
  gem.license       = "Apache 2.0"
  gem.homepage      = "https://github.com/FunnelEnvy/embulk-plugin-redis"

  gem.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.has_rdoc      = false

  gem.add_dependency 'redis', ['>= 3.0.5']
  gem.add_development_dependency 'bundler', ['~> 1.0']
  gem.add_development_dependency 'rake', ['>= 0.9.2']
end
