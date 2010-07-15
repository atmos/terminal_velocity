require File.dirname(__FILE__) + '/spec_helper'

hosts =  [ ENV['SSH_HOSTS'] || 'atmos.org' ]

describe "login to #{hosts.inspect}" do
  let(:user)  { ENV['USER'] }

  it "logs you into your instances" do
    TerminalVelocity.launch(user, hosts)
  end
end
