require "simplecov"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  SimpleCov::Formatter::HTMLFormatter,
)
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require "pry"
require "lita-server_status"
require "lita/rspec"
Lita.version_3_compatibility_mode = false
