#
# Cookbook Name:: apptentive_zookeeper
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Apptentive, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

package "bsdtar"

download_url  = "#{node["zookeeper"]["apache_mirror"]}/zookeeper/zookeeper-#{node["zookeeper"]["version"]}/zookeeper-#{node["zookeeper"]["version"]}.tar.gz"
zookeeper_tgz = "#{Chef::Config[:file_cache_path]}/#{File.basename(download_url)}"
version_path  = "#{node["zookeeper"]["versions_dir"]}/#{node["zookeeper"]["version"]}"

group node["zookeeper"]["group"] do
  system true
end

user node["zookeeper"]["user"] do
  comment "zookeeper"
  gid node["zookeeper"]["group"]
  home node["zookeeper"]["current_path"]
  shell "/sbin/nologin"
  system  true
end

directory version_path do
  owner node["zookeeper"]["user"]
  group node["zookeeper"]["group"]
  recursive true
  notifies :run, "execute[unpack zookeeper]"
end


remote_file zookeeper_tgz do
  source download_url
  notifies :run, "execute[unpack zookeeper]"
end

execute "unpack zookeeper" do
  user node["zookeeper"]["user"]
  command "bsdtar -xf #{zookeeper_tgz} -C #{version_path} --strip 1"
  action :nothing
end

link node["zookeeper"]["current_path"] do
  to version_path
end

%w(indexes snapshots transactions).each do |dir|
  directory "#{node["zookeeper"]["data_root"]}/#{dir}" do
    owner node["zookeeper"]["user"]
    group node["zookeeper"]["group"]
    recursive true
  end
end

directory '/var/log/zookeeper' do
  owner node['zookeeper']['user']
  group node['zookeeper']['user']
end
