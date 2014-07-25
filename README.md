# lita-server_status

Store and list out the statuses of applications (prod/staging)

## Installation

Add lita-server_status to your Lita instance's Gemfile:

``` ruby
gem "lita-server_status"
```

## Configuration

No configuration variables needed.

Lita looks for strings following this regex: ```/(.+) is starting deploy of '(.+)' from branch '(.+)' to (.+)/i```

Which looks like: 'Waffle McRib is starting deploy of 'BATMAN' from branch 'AWESOME' to STAGING'

## Usage

``` lita server status ```

List out the server statuses.

## Output:

```
  BATMAN STAGING: AWESOME (Waffle McRib @ 2014-07-24 12:10:54 -0600)
  FAKEAPP PRODUCTION: MASTER (Waffle McRib @ 2014-07-24 12:10:54 -0600)
```

## License

[MIT](http://opensource.org/licenses/MIT)
