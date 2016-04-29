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
        'is_json' => config.param('is_json', :boolean, :default => false),
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
        # puts "key field: #{task['key']}"
        # puts "key: #{record[0][task['key']]}"
        # If the data being stored is known to be JSON.
        if task['is_json']
          @redis.set(record[0][task['key']], record[0].to_json)
        else
          @redis.set(hash[task['key']], hash)
        end
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
