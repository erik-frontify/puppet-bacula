require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'
require 'rspec-puppet-facts'
include RspecPuppetFacts

# Uncomment this to show coverage report, also useful for debugging
at_exit { RSpec::Puppet::Coverage.report! }

# set to "yes" to enable strict variable checking, the equivalent of setting strict_variables=true in puppet.conf.
ENV['STRICT_VARIABLES'] = 'yes'

# set to the desired ordering method ("title-hash", "manifest", or "random") to set the order of unrelated resources
# when applying a catalog. Leave unset for the default behavior, currently "random". This is equivalent to setting
# ordering in puppet.conf.
ENV['ORDERING'] = 'random'

# set to "yes" to enable the $facts hash and trusted node data, which enabled $facts and $trusted hashes.
# This is equivalent to setting trusted_node_data=true in puppet.conf.
ENV['TRUSTED_NODE_DATA'] = 'yes'

RSpec.configure do |c|
    c.formatter = 'documentation'
    c.mock_with :rspec
    c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
    c.after(:suite) do
        RSpec::Puppet::Coverage.report!(20)
    end
end
