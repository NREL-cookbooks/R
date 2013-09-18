# install via apt-get in debian
if platform_family?("debian")

  apt_repository "cran-r" do
    uri node[:R][:apt_uri]
    distribution node[:R][:apt_distribution]
    keyserver "keyserver.ubuntu.com"
    key node[:R][:apt_key]
  end

  package "r-base" do
    #version "2.15.3-1precise0precise1" # not sure why, but this isn't working
    action :install
  end
end


# make sure that java is dynamically loaded (if needed)
if node[:R][:add_ld_path]
  template "/etc/profile.d/r-config.sh" do
    source "r-config.sh.erb"
    owner "root"
    mode "0775"
  end
end


node[:R][:packages].each do |package|
  bash "install #{package[:name]} version #{package[:version]}" do
    cwd "/tmp"
    if package[:name] == "rJava"
      package_name = "#{package[:name]}_#{package[:version]}.tar.gz"

      code <<-EOH
        sudo R CMD javareconf
        wget #{node[:R][:package_source_url]}/#{package_name}
        R CMD INSTALL #{package_name}
      EOH
    else
      package_name = "#{package[:name]}_#{package[:version]}.tar.gz"

      code <<-EOH
        wget #{node[:R][:package_source_url]}/#{package_name}
        R CMD INSTALL #{package_name}
      EOH
    end
    not_if { ::File.exists?("/tmp/#{package_name}") }
  end
end

template "/etc/Rserv.conf" do
  source "Rserv.conf.erb"
  owner "root"
  mode "0755"
end

if node[:R][:rserve_start_on_boot]
  template "/etc/init.d/Rserved" do
    source "Rserved.erb"
    owner "root"
    mode "0755"
  end

  template "/usr/lib/R/bin/Rserve.sh" do
    source "Rserve.sh.erb"
    owner "root"
    mode "0755"
  end

  # go ahead and kick it off now because we aren't going to reboot
  bash "run Rserved" do
    code <<-EOH
      cd /etc/init.d/
      update-rc.d Rserved defaults
    EOH
  end

  service "Rserved" do
    action :start
  end
end

