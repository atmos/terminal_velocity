require 'tmpdir'
require 'digest/sha1'

module TerminalVelocity
  def self.launch(username, hostnames)
    users_at_hostnames = hostnames.map { |hostname| "#{username}@#{hostname}" }
    Runner.new(users_at_hostnames).run
  end

  class Runner
    def initialize(users_at_hostnames)
      @users_at_hostnames = users_at_hostnames
    end

    def run
      generate_script
      launch
    end

    private
      def generate_script
        File.open(script_filename, "w") do |fp|
          fp.write(ERB.new(File.read(template)).result(binding))
        end
      end

      def launch
        %x{osascript "#{script_filename}" 2>/dev/null}
      end

      def script_filename
        "#{Dir.tmpdir}.#{script_sha1}.terms"
      end

      def template
        File.join(File.dirname(__FILE__), "terminal_velocity", "templates", "applescript.ssh.erb")
      end

      def script_sha1
        @script_sha1 ||= Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      end
  end
end
