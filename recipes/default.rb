

# install via apt-get in debian
if platform_family?("debian")
  bash "install R" do
    code <<-EOH
        apt-get -f install r-base  -y
    EOH
  end
end
