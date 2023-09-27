# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'rails_helper'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
  add_filter 'app/serializers'
  add_filter 'app/controllers/concerns'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation
end
