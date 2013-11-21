# install via apt-get in debian
if platform_family?("debian")
  if node[:R][:build_from_source]
    bash "install and compile R-base from #{node[:R][:build_source_url]}" do
      cwd "/tmp"
      package_name = "R-#{node[:R][:build_version]}.tar.gz"

      code <<-EOH
            wget #{node[:R][:build_source_url]}/#{package_name}
            mv #{package_name} /usr/local/lib/#{package_name}
            cd "/usr/local/lib"
            tar -xf #{package_name}
            cd R-#{node[:R][:build_version]}
            sed -i 's/NCONNECTIONS 128/NCONNECTIONS 2560/' src/main/connections.c
            sudo apt-get update
            sudo apt-get install gfortran -y
            sudo apt-get build-dep r-base -y
            ./configure --prefix=/usr --enable-R-shlib
            make -j4
            make install
      EOH

      not_if { ::File.exists?("/usr/bin/R") }
    end
  else
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
    
    package_url = package[:source_url] ? package[:source_url] : node[:R][:default_package_url] 
    if package[:name] == "rJava"
      package_name = "#{package[:name]}_#{package[:version]}.tar.gz"
      
      code <<-EOH
            sudo R CMD javareconf
            wget #{package_url}/#{package_name}
            R CMD INSTALL #{package_name}
      EOH
    else
      package_name = "#{package[:name]}_#{package[:version]}.tar.gz"

      code <<-EOH
            wget #{package_url}/#{package_name}
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
  template "/etc/init.d/Rserve" do
    source "Rserve.erb"
    owner "root"
    mode "0755"
  end

  # go ahead and kick it off now because we aren't going to reboot
  bash "configure Rserve daemon" do
    code <<-EOH
        cd /etc/init.d/
        update-rc.d Rserve defaults
    EOH
  end

  service "Rserve" do
    action :restart
  end
end

