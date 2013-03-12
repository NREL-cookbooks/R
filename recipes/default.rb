

# install via apt-get in debian
if platform_family?("debian")
  bash "install R" do
    code <<-EOH
      echo "deb http://cran.stat.ucla.edu/bin/linux/ubuntu precise/" >> /etc/apt/sources.list
      apt-get update
      apt-get -f install r-base r-base-dev -y --force-yes
    EOH
  end

  not_if { ::File.exists?("/usr/bin/R") }
end

bash "install packages" do
  cwd "/tmp"
  code <<-EOH

    wget http://cran.r-project.org/src/contrib/lhs_0.10.tar.gz
    R CMD INSTALL lhs_0.10.tar.gz

    wget http://cran.r-project.org/src/contrib/Rserve_0.6-8.tar.gz
    R CMD INSTALL Rserve_0.6-8.tar.gz
  EOH
end
