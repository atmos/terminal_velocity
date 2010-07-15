require 'tmpdir'
require 'digest/sha1'

require File.dirname(__FILE__) + "/terminal_velocity/templates"

module TerminalVelocity
  def self.launch(username, hostnames)
    users_at_hostnames = hostnames.map { |hostname| "#{username}@#{hostname}" }
    TerminalVelocity::Templates::AppleScripter.new(users_at_hostnames).run
  end
end
