#!/bin/sh
aptitude update -y
aptitude safe-upgrade -y
aptitude install -y git-core ruby1.8-dev build-essential libxslt1-dev libpcre3-dev wget rubygems libcurl4-dev irb
git clone git://github.com/fizx/parsley.git
wget http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz
tar -zxvf json-c-0.9.tar.gz
cd json-c-0.9
./configure && make && make install
ldconfig -v
cd -
cd parsley
./configure && make check && make install
cd -
gem sources -a http://gems.github.com
gem install --no-rdoc --no-ri fizx-csvget
ls /var/lib/gems/1.8/bin | xargs -I % ln -nfs /var/lib/gems/1.8/bin/% /usr/local/bin/