%w(opwn_sesame sinatra/test/rspec).each { |f| require f }

include Sinatra::Test::Methods

Sinatra::Application.default_options.merge!(
  :env => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)