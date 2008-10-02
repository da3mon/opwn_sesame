%w(opwn_sesame).each { |f| require f }
require 'spec/interop/test'
require 'sinatra/test/methods'
puts YAML.dump(Sinatra.application.events)

include Sinatra::Test::Methods

Sinatra::Application.default_options.merge!(
  :env => :test,
  :run => false,
  :raise_errors => true,
  :logging => true
)

