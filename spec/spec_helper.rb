require "simplecov"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
]
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require "lita-server_status"
require "lita/rspec"
