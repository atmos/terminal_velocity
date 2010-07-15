require 'pp'
Bundler.require(:default, :runtime, :test)

require File.join(File.dirname(__FILE__), '..', 'lib', 'terminal_velocity')

Spec::Runner.configure do |config|
  config.before(:each) do
  end
end
