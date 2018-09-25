# lita-server_status

Store and list out the statuses of applications (prod/staging)

## Installation

Add lita-server_status to your Lita instance's Gemfile:

``` ruby
gem "lita-server_status"
```

## Configuration

No configuration variables needed.

Lita looks for strings following this regex: ```/(?::eyes:)*\s*(.+) is deploying (.+)\/(.+) to (.+)/i```

Which looks like:

`:eyes: Tammy Tester is deploying App/Environment to BranchName`

or

`Tammy Tester is deploying App/Environment to BranchName`

## Usage

``` lita server status ```

List out the server statuses.

## Output:

```
  App STAGING: Branch (Tammy Tester @ 2014-07-24 12:10:54 -0600)
  App PRODUCTION: Branch (Tammy Tester @ 2014-07-24 12:10:54 -0600)
```

## License

[MIT](http://opensource.org/licenses/MIT)
