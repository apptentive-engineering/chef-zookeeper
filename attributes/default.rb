default["zookeeper"]["version"] = "3.4.6"

default["zookeeper"]["apache_mirror"] = "http://apache.osuosl.org"

default["zookeeper"]["install_root"] = "/opt/zookeeper"
default["zookeeper"]["current_path"] = "#{node["zookeeper"]["install_root"]}/current"
default["zookeeper"]["versions_dir"] = "#{node["zookeeper"]["install_root"]}/versions"

default["zookeeper"]["user"]  = "zookeeper"
default["zookeeper"]["group"] = "zookeeper"

default["zookeeper"]["data_root"] = "#{node["zookeeper"]["install_root"]}/data"
