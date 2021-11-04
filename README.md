# test kitchen docker serverspec bug demo

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
