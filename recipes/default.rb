

# install via apt-get in debian
if platform_family?("debian")
  bash "install R" do
    code <<-EOH
      echo "deb http://cran.stat.ucla.edu/bin/linux/ubuntu precise/" >> /etc/apt/sources.list
      apt-get update
      apt-get -f install r-base r-base-dev -y --force-yes
    EOH

    not_if { ::File.exists?("/usr/bin/R") }
  end
end


node['R']['packages'].each do |package|
  bash "install #{package['name']} version #{package['version']}" do
    cwd "/tmp"

    package_name = "#{package['name']}_#{package['version']}.tar.gz"

    code <<-EOH
      wget #{node['R']['source_url']}/#{package_name}
      R CMD INSTALL #{package_name}
    EOH

    not_if { ::File.exists?("/tmp/#{package_name}") }
  end
end
