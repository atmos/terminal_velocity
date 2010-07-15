require File.dirname(__FILE__) + '/spec_helper'

hosts =  [ ENV['SSH_HOSTS'] || 'atmos.org' ]

describe "login to #{hosts.inspect}" do
  let(:user)  { ENV['USER'] }

  it "logs you into your instances" do
    TerminalVelocity.launch(user, hosts)
  end

  it "logs you into your instances via screen" do
    TerminalVelocity::Templates::Screen.run(user, hosts)
  end
end
