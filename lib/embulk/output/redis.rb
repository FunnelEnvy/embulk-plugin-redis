module Embulk

  class OutputRedis < OutputPlugin
    require 'redis'

    Plugin.register_output('redis', self)

    def self.transaction(config, schema, processor_count, &control)
      task = {
        'host' => config.param('host', :string, :default => 'localhost'),
        'port' => config.param('port', :integer, :default => 6379),
        'db' => config.param('db', :integer, :default => 0),
        'key' => config.param('key', :string),
        'url' => config.param('url', :string),
      }

      puts "Redis output started."
      commit_reports = yield(task)
      puts "Redis output finished. Commit reports = #{commit_reports.to_json}"

      return {}
    end

    def initialize(task, schema, index)
      puts "Example output thread #{index}..."
      super
      @records = 0
      if task['url'].nil? || task['url'].empty?
        @redis = ::Redis.new(:host => task['host'], :port => task['port'], :db => task['db'])
      else
        @redis = ::Redis.new(:url => task['url'])
      end
    end

    def close
    end

    def add(page)
      page.each do |record|
        hash = Hash[schema.names.zip(record)]
        puts "#{@message}: #{hash.to_json}"
        @redis.set(hash[task['key']], hash)
        @records += 1 
      end
    end

    def finish
    end

    def abort
    end

    def commit
      commit_report = {
        "records" => @records
      }
      return commit_report
    end
  end

end
