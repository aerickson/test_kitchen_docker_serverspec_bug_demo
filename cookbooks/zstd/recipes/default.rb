file "/tmp/greeting.txt" do
  content node['my_cookbook']['greeting']
end

package 'Install zstd' do
  case node[:platform]
  # when 'redhat', 'centos'
  #   package_name 'httpd'
  when 'ubuntu', 'debian'
    package_name 'zstd'
  end
end