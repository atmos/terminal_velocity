require 'tmpdir'

module TerminalVelocity
  def self.launch(username, hostnames)
    script_filename = "#{Dir.tmpdir}.#{hostnames.object_id}.terminals"
    template        = File.join(File.dirname(__FILE__), "terminal_velocity", "templates", "applescript.ssh.erb")

    File.open(script_filename, "w") do |fp|
      fp.write(ERB.new(File.read(template)).result(binding))
    end

    %x{osascript "#{script_filename}" 2>/dev/null}
  end
end
