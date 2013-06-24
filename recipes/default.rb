# install via apt-get in debian
if platform_family?("debian")

  apt_repository "cran-r" do
    uri node['R']['apt_uri']
    distribution node['R']['apt_distribution']
    keyserver "keyserver.ubuntu.com"
    key node['R']['apt_key']
  end

  package "r-base" do
    #version "2.15.3-1precise0precise1" # not sure why, but this isn't working
    action :install
  end
end

node['R']['packages'].each do |package|
  bash "install #{package['name']} version #{package['version']}" do
    cwd "/tmp"

    package_name = "#{package['name']}_#{package['version']}.tar.gz"

    code <<-EOH
      wget #{node['R']['package_source_url']}/#{package_name}
      R CMD INSTALL #{package_name}
    EOH

    not_if { ::File.exists?("/tmp/#{package_name}") }
  end
end
