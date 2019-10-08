# run a test task
require 'spec_helper_acceptance'

describe 'mysql tasks', if: os[:family] != 'sles' do
  describe 'execute some sql' do
    pp = <<-MANIFEST
        class { 'tp_profile::apache': }
    MANIFEST

    it 'sets up a mysql instance' do
      apply_manifest(pp, catch_failures: true)
    end

  end
end
