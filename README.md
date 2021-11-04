# test kitchen docker serverspec bug demo

full output below

looks to be due to a change in bundler v2.2.30 (problem not present when using v2.2.29)

https://github.com/rubygems/rubygems/compare/bundler-v2.2.29...bundler-v2.2.30

## finding exact commit via bisect

first clone https://github.com/rubygems/rubygems in /tmp/kitchen.

test script:

```
#!/usr/bin/env bash
set -e
set -x

ROOT=/tmp/kitchen

cd $ROOT/rubygems/bundler
gem uninstall bundler -ax
rm *.gem
gem build *.gemspec
gem install *.gem
cd $ROOT
bundle install
```

bisect reveals:

```
3f5dce51add904823e59b6423a23748885023810 is the first bad commit
commit 3f5dce51add904823e59b6423a23748885023810
Author: David Rodríguez <deivid.rodriguez@riseup.net>
Date:   Wed Oct 13 09:21:36 2021 +0200

    Merge pull request #4974 from rubygems/bundle_install_reinstalls_deleted_gems
    
    Fix `bundle install` to reinstall deleted gems
    
    (cherry picked from commit 8a0003f826270eb9b3a2c4a1508887d4e75f5617)

:040000 040000 3343a3458db9c19c13cb05669823ae7c5855d641 1f1590efcd14bd5813f42381bbfdbeaac0dc5588 M	bundler
```

https://github.com/rubygems/rubygems/pull/4974

## error output

```
       Successfully installed bundler-2.2.30
       1 gem installed
       ---> BUNDLE_CMD variable is: /usr/local/bin/bundle
       Don't run Bundler as root. Bundler can ask for sudo if it is needed, and
       installing your bundle as root will break this application for all non-root
       users on this machine.
       Fetching gem metadata from https://rubygems.org/....
       Resolving dependencies...
       Using bundler 2.2.30
       Fetching diff-lcs 1.4.4
       Fetching multi_json 1.15.0
       Installing multi_json 1.15.0
       Installing diff-lcs 1.4.4
       Fetching net-ssh 3.2.0
       Installing net-telnet 0.1.1
       Fetching rspec-support 3.10.3
       Installing rspec-support 3.10.3
       Fetching sfl 2.3
       Installing net-ssh 3.2.0
       Installing sfl 2.3
       Fetching rspec-core 3.10.1
       Fetching rspec-expectations 3.10.1
       Installing rspec-core 3.10.1
       Installing rspec-expectations 3.10.1
       Fetching rspec-mocks 3.10.2
       Fetching net-scp 3.0.0
       Installing net-scp 3.0.0
       Fetching rspec-its 1.3.0
       Installing rspec-mocks 3.10.2
       Installing rspec-its 1.3.0
       Bundler::GemNotFound: Could not find net-telnet-0.1.1.gem for installation
        
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/source/rubygems.rb:177:in
       `install'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/installer/gem_installer.rb:54:in
       `install'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/installer/gem_installer.rb:16:in
       `install_from_spec'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/installer/parallel_installer.rb:186:in
       `do_install'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/installer/parallel_installer.rb:177:in
       `block in worker_pool'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/worker.rb:62:in
       `apply_func'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/worker.rb:57:in `block in
       process_queue'
         /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/worker.rb:54:in `loop'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/worker.rb:54:in
       `process_queue'
       /var/lib/gems/2.5.0/gems/bundler-2.2.30/lib/bundler/worker.rb:91:in `block (2
       levels) in create_threads'
       
       An error occurred while installing net-telnet (0.1.1), and Bundler
       cannot continue.
       
       In Gemfile:
         serverspec was resolved to 2.41.8, which depends on
           specinfra was resolved to 2.83.1, which depends on
             net-telnet
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: 1 actions failed.
>>>>>>     Failed to complete #verify action: [SSH exited (5) for command: [            
            if [ ! $(which ruby) ]; then
              echo '-----> Installing ruby, will try to determine platform os'
              if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] || [ -f /etc/oracle-release ]; then
                sudo -E -H yum -y install ruby
              else
                if [ -f /etc/system-release ] && grep -q 'Amazon Linux' /etc/system-release; then
                  sudo -E -H yum -y install ruby
                else
                  sudo -E -H apt-get -y update
                  sudo -E -H apt-get -y install ruby
                fi
              fi
            fi
                        if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] || [ -f /etc/oracle-release ]; then
              echo '-----> Installing os provided bundler package'
              sudo -E -H yum -y install rubygem-bundler
            else
              echo '-----> Installing bundler via rubygems'
              if [ "$(sudo -E -H gem list bundler -i)" = "true" ]; then
                echo "Bundler already installed"
              else
                if [ "$(sudo -E -H gem list bundler -i)" = "false" ]; then
                  sudo -E -H gem install  --no-ri --no-rdoc bundler
                else
                  echo "ERROR: Ruby not installed correctly"
                  exit 1
                fi
              fi
            fi

            if [ -d /tmp/kitchen ]; then
                            if [ "$(sudo -E -H gem list serverspec -i)" = "false" ]; then
                        sudo -E -H rm -f /tmp/kitchen/Gemfile
          sudo -E -H echo "source 'https://rubygems.org'" >> /tmp/kitchen/Gemfile
          sudo -E -H echo "gem 'net-ssh','~> 3'"  >> /tmp/kitchen/Gemfile
          sudo -E -H echo "gem 'serverspec'" >> /tmp/kitchen/Gemfile

              BUNDLE_CMD=$(which bundle)
              echo "---> BUNDLE_CMD variable is: ${BUNDLE_CMD}"
              sudo -E -H  $BUNDLE_CMD install --gemfile=/tmp/kitchen/Gemfile
            fi

              
            else
              echo "ERROR: Default path '/tmp/kitchen' does not exist"
              exit 1
            fi
]] on linux-ubuntu-1804
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details
>>>>>> Also try running `kitchen diagnose --all` for configuration
Error: Process completed with exit code 20.
```
