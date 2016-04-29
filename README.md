# Embulk input/output plugin for Redis

This is a fork of https://github.com/frsyuki/embulk-plugin-redis

The biggest change is that it accepts a Redis URL connection string.
This makes it easy to output to a Compose.io hosted Redis for example.

It also fixes a few issues and adds some support for working with JSON. It will now,
optionally, save a JSON string into Redis with the output plugin. Otherwise, it 
stores a hash.

This plugin runs without transaction for now.

## Configuration

- **host** host name of the Redis server (string, default: "localhost")
- **port** port of the Redis server (integer, default: 6379)
- **db** destination database number (integer, default: 0)
- **key_prefix** key prefix to search keys for input plugin (string)
- **key** key name for output plugin (string, required)

### Example

```yaml
out:
  type: redis
  host: localhost
  port: 6379
  db: 0
  key: user_name

in:
  type: redis
  host: localhost
  port: 6379
  db: 0
  key_prefix: user_
```

### New Feature Example

Assuming Embulk is ingesting log files with line by line JSON strings...This will import
to Redis using a key found within the JSON object. An example line item may be:

```{"id": "myId", "name": "Bob"}```

The following configuration would use the id value "myId" as a key in Redis with a string
value of the entire record.

```yaml
out:
  type: redis
  url: redis://x:21345@host.com:6379
  db: 0
  is_json: true
  key: id
```