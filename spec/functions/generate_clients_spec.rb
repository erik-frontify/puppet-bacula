require 'spec_helper'

describe 'bacula::generate_clients' do
  it { is_expected.to run.with_params({}).and_not_raise_error }

  it 'accepts a clients hash without error' do
    clients = {
      'client1.example.com' => {
        'fileset'         => 'Basic:noHome',
        'client_schedule' => 'WeeklyCycle',
      },
    }
    is_expected.to run.with_params(clients).and_not_raise_error
  end
end
