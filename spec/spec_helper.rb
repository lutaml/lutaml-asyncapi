# frozen_string_literal: true

require "lutaml/asyncapi"

FIXTURES = File.expand_path("fixtures", __dir__).freeze

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.disable_monkey_patching!
  config.order = :random
end
