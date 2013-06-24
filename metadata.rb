name             'R'
maintainer       'NREL'
maintainer_email 'nicholas.long@nrel.gov'
license          'LGPL'
description      'Installs/Configures R Project for Statistical Computing '
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

#if platform?("redhat", "centos", "fedora")
#  depends "yum"
#elsif platform?("ubuntu")
  depends "apt"
#end