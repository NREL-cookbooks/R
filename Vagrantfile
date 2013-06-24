# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-precise-64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "../"

    chef.add_recipe "apt"
    chef.add_recipe "R"


    chef.json = {
        'R' => {
            'apt_distribution' => "precise/",
            'apt_key' => "E084DAB9",
            'package_source_url' => "http://cran.r-project.org/src/contrib",
            'packages' => [
                {
                    'name' => 'lhs',
                    'version' => '0.10'},
                {
                    'name' => 'Rserve',
                    'version' => '0.6-8.1'},
                {
                    'name' => 'triangle',
                    'version' => '0.8'}
            ]
        }
    }


  end
end
