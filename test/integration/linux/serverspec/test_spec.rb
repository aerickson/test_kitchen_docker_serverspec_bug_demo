require_relative 'spec_helper'

describe 'users' do
  describe user('root') do
    it { should exist }
  end
end
