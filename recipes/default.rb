

# install via apt-get in debian
if platform_family?("debian")
  bash "install R" do
    code <<-EOH
        apt-get install r-base
    EOH
  end
end
