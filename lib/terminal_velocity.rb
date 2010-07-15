require 'tmpdir'
require 'digest/sha1'

require File.dirname(__FILE__) + "/terminal_velocity/templates"

module TerminalVelocity
  def self.launch(username, hostnames)
    TerminalVelocity::Templates::AppleScripter.run(username, hostnames)
  end
end
