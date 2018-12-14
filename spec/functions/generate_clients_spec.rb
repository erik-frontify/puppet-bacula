require 'spec_helper'

describe 'generate_clients' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      it "should exist" do
        Puppet::Parser::Functions.function("generate_clients").should == "function_generate_clients"
      end

    end
  end
end
