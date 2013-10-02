default[:R][:apt_uri] = "http://cran.stat.ucla.edu/bin/linux/ubuntu"
default[:R][:apt_distribution] = "precise/"
default[:R][:apt_key] = "E084DAB9"
default[:R][:package_source_url] = "http://cran.r-project.org/src/contrib"


# rserve settings
default[:R][:rserve_start_on_boot] = false
default[:R][:rserve_user] = "vagrant"
default[:R][:rserve_log_path] = "/var/log/Rserve.log"


# if linux debian
default[:R][:add_ld_path] = false
default[:R][:java_libjvm_path] = "/usr/lib/jvm/java-6-openjdk-amd64/jre/lib/amd64/server/"
