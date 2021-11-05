require_relative 'spec_helper'

describe 'users' do
  describe user('root') do
    it { should exist }
  end
end

describe bash('date -h') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end

describe command('date -h') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end

describe command('/bin/date -h') do
  its('exit_status') { should eq 1 }
  # its('stdout') { should match /Usage/ }
end
