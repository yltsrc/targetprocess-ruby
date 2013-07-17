require 'rspec/autorun'
require 'targetprocess'
require 'vcr'
require 'lib/targetprocess/shared_examples_for_assignables_spec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
end
			
# Run this commands in case you want to send any request to api, otherwise
# VCR and WebMock will not allow you
# VCR.turn_off!
# WebMock.allow_net_connect!
