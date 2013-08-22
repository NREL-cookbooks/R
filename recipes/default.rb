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

    package_name = "#{package[:name]}_#{package[:version]}.tar.gz"

    code <<-EOH
      wget #{node[:R][:package_source_url]}/#{package_name}
      R CMD INSTALL #{package_name}
    EOH

    not_if { ::File.exists?("/tmp/#{package_name}") }
  end
end

template "/etc/Rserv.conf" do
  source  "Rserv.conf.erb"
  owner   "root"
  mode    "0755"
end

template "/etc/init.d/Rserved" do
  source "Rserved.erb"
  owner   "root"
  mode    "0755"
end

template "/usr/local/bin/R/Rserve.sh" do
  source "Rserve.sh.erb"
  owner   "root"
  mode    "0755"
end

if node[:R][:rserve_start_on_boot]
  bash "putting R into rc2.d" do

  end

end
bash ""

Rserved goes in the /etc/init.d/ dir

Need to execute:  cd /etc/rc2.d; sudo ln -s ../init.d/Rserved S99Rserved

Permissions on both files need to be chmod 774, at least that worked…
