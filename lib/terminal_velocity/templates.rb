module TerminalVelocity
  module Templates
    class Runner
      def self.run(username, hostnames, custom_options = { })
        users_at_hostnames = hostnames.map { |hostname| "#{username}@#{hostname}" }

        runner = new(users_at_hostnames)
        runner.options.merge!(custom_options)
        runner.run
      end

      def initialize(users_at_hostnames)
        @users_at_hostnames = users_at_hostnames
      end

      def run
        generate_script
        launch
      end

      def options
        @options ||= { :term_theme => "Pro", :current_window => false }
      end

      private
        def ssh_command(user_at_hostname)
          "clear; ssh -o StrictHostKeyChecking=no #{user_at_hostname}"
        end

        def generate_script
          File.open(script_filename, "w") do |fp|
            fp.write(ERB.new(File.read(template)).result(binding))
          end
        end

        def launch
          results = `#{launcher_script} "#{script_filename}" 2>&1`
          if $?.to_i != 0
            case results
              when /Can’t get window 1 whose frontmost = true. Invalid index/
                $stderr.puts("You need to 'Enable access for assistive devices.'")
              else
            end
          end
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
      def self.run(username, hostnames, options = { })
        super(username, hostnames, { :script_name => "terminal-velocity-#{$$}" }.merge(options))
      end

      def launcher_script
        "screen -S #{options[:script_name]} -c"
      end

      def template
        File.join(File.dirname(__FILE__), "templates", "screenrc.erb")
      end
    end
  end
end
