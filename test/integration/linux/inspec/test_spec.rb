require_relative 'spec_helper'

describe 'users' do
  describe user('root') do
    it { should exist }
  end
end

describe bash('zstd') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end

describe command('zstd') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end

describe command('zstd') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end
