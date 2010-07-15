module TerminalVelocity
  module Templates
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
          %x{#{launcher_script} "#{script_filename}" 2>/dev/null}
        end

        def script_filename
          "#{Dir.tmpdir}.#{script_sha1}.terms"
        end

        def script_sha1
          @script_sha1 ||= Digest::SHA1.hexdigest(Time.now.to_f.to_s)
        end

        def launcher_script
          raise ArgumentError, "implement #launcher_script"
        end

        def template
          raise ArgumentError, "implement #template"
        end
    end

    class AppleScripter < Runner
      def launcher_script
        "osascript"
      end

      def template
        File.join(File.dirname(__FILE__), "templates", "applescript.ssh.erb")
      end
    end

    class Screen < Runner
      def launcher_script
        "screen -S terminal-velocity-#{script_sha1} -c"
      end

      def template
        File.join(File.dirname(__FILE__), "templates", "screenrc.erb")
      end
    end
  end
end

